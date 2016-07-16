//
//  ListaPrincipalTableViewController.swift
//  DreamNotes
//
//  Created by Vinícius Bazanelli on 01/10/14.
//  Copyright (c) 2014 Baza Inc. All rights reserved.
//

import UIKit
import CoreData
import iAd

class ListaPrincipalTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, ADBannerViewDelegate{
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var iMinSessions = 3
    var iTryAgainSessions = 6
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    var bannerView: ADBannerView?
    var dream: Dreams? = nil
    
    @IBOutlet weak var configBtnItem: UIBarButtonItem!
    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if LITE
            // iAd
            self.canDisplayBannerAds = true
            self.bannerView?.delegate = self
            self.bannerView?.hidden = true
        #endif
        
        // ----- iOS Version -----
        func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: NSString) -> Bool {
            return UIDevice.currentDevice().systemVersion.compare(version as String,
                options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending
        }
        
        // STYLE
        //let settingsImg: UIImage = UIImage(named: "Settings")!
        //configBtnItem.setBackgroundImage(settingsImg, forState: .Normal, barMetrics: .Default)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Chalkduster", size: 24.0)!,
            NSForegroundColorAttributeName: UIColor(red: 255, green:255, blue: 255, alpha: 1)
        ]
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "nuvem"))
        //receive notifications when the preferred content size changes
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "preferredContentSizeChanged:",
            name: UIContentSizeCategoryDidChangeNotification,
            object: nil)
        
        //Set Notifications Observers
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"makeALog:",
            name: "actionNoPressed",
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"redirectToEditor:",
            name: "actionNotePressed",
            object: nil)
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        }catch{
            "deu merda: \(error)"
        }
        
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8"){
            rateMe()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
    #if LITE
    func bannerViewDidLoadAd(banner: ADBannerView!) {
    self.bannerView?.hidden = false
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
    return willLeave
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
    self.bannerView?.hidden = true
    }
    #endif
    
    func rateMe() {
        let neverRate = NSUserDefaults.standardUserDefaults().boolForKey("neverRate")
        var numLaunches = NSUserDefaults.standardUserDefaults().integerForKey("numLaunches") + 1
        
        if (!neverRate && (numLaunches == iMinSessions || numLaunches >= (iMinSessions + iTryAgainSessions + 1)))
        {
            showRateMe()
            numLaunches = iMinSessions + 1
        }
        NSUserDefaults.standardUserDefaults().setInteger(numLaunches, forKey: "numLaunches")
    }
    
    func showRateMe() {
        let alert = UIAlertController(title: NSLocalizedString("Rate_us_title", comment: "Rate Us"), message: NSLocalizedString("Rate_us_msg", comment: "Thanks for using Dream Notes\nWe hope you have sweet dreams"), preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("No-thx", comment: "No Thanks"), style: UIAlertActionStyle.Default, handler: {
            alertAction in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRate")
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Maybe", comment: "Maybe Later"), style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Rate", comment: "Rate Dream Notes!"), style: UIAlertActionStyle.Default, handler: { alertAction in
            UIApplication.sharedApplication().openURL(NSURL(string : "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=949218227&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8")!)
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func makeALog(notification:NSNotification){
        //Make a log when dismissed the Notificaition
        print("NO - Dismissed Notification Pressed")
        
    }
    
    func redirectToEditor(notification:NSNotification){
        print("Note - Pressed")
        
        //Redirect to DreamEditorViewController when Notification is pressed
        self.performSegueWithIdentifier("create", sender: self)
        
        func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
            if segue.identifier == "create" {
                let de = segue.destinationViewController as! DreamEditorViewController
            }
        }
    }
    
    func preferredContentSizeChanged(notification: NSNotification) {
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        
        if segue.identifier == "edit" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let dreamController:DreamUpdaterViewController = segue.destinationViewController as! DreamUpdaterViewController
            let dream:Dreams = fetchedResultController.objectAtIndexPath(indexPath!) as! Dreams
            dreamController.dream = dream
        }
        
        if segue.identifier == "config"{
            let settings:SetNotificationViewController = segue.destinationViewController as! SetNotificationViewController
        }
    }
    
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Dreams")
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections = fetchedResultController.sections?.count
        // porquice para o iOS7.1
        if numberOfSections == nil {
            numberOfSections = 0;
        }
        return numberOfSections!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CustomCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomCell
        let dream = fetchedResultController.objectAtIndexPath(indexPath) as! Dreams
        
        if(indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.clearColor()
        }else{
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
            //cell.textLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        }
        
        //cell.textLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.desc.text = dream.title
        cell.data.text = dream.data
        return cell
    }
    
    //Delete
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject
        managedObjectContext?.deleteObject(managedObject)
        do{
            try managedObjectContext?.save()
        }catch{
            print("NÃO SALVO")
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
}
