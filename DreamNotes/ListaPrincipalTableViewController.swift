//
//  ListaPrincipalTableViewController.swift
//  DreamNotes
//
//  Created by Vinícius Bazanelli on 01/10/14.
//  Copyright (c) 2014 Baza Inc. All rights reserved.
//

import UIKit
import CoreData

class ListaPrincipalTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    
    var iMinSessions = 3
    var iTryAgainSessions = 6
    var dream: Dreams? = nil
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> = NSFetchedResultsController()
    
    @IBOutlet weak var configBtnItem: UIBarButtonItem!
    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        // STYLE
        //let settingsImg: UIImage = UIImage(named: "Settings")!
        //configBtnItem.setBackgroundImage(settingsImg, forState: .Normal, barMetrics: .Default)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 24.0)!,
            NSAttributedStringKey.foregroundColor: UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        ]
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "night-sky-stars"))
        
        //receive notifications when the preferred content size changes
        NotificationCenter.default.addObserver(self,
                                                         selector: "preferredContentSizeChanged:",
                                                         name: NSNotification.Name.UIContentSizeCategoryDidChange,
                                                         object: nil)
        
        //Set Notifications Observers
        NotificationCenter.default.addObserver(self,
                                                         selector:"makeALog:",
                                                         name: NSNotification.Name(rawValue: "actionNoPressed"),
                                                         object: nil)
        
        NotificationCenter.default.addObserver(self,
                                                         selector:"redirectToEditor:",
                                                         name: NSNotification.Name(rawValue: "actionNotePressed"),
                                                         object: nil)
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        }catch{
            NSLog("deu merda: \(error)")
            fatalError("Failed to fetch entities: \(error)")
        }
        
        rateMe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
    }
    
    func rateMe() {
        let neverRate = UserDefaults.standard.bool(forKey: "neverRate")
        var numLaunches = UserDefaults.standard.integer(forKey: "numLaunches") + 1
        
        if (!neverRate && (numLaunches == iMinSessions || numLaunches >= (iMinSessions + iTryAgainSessions + 1)))
        {
            showRateMe()
            numLaunches = iMinSessions + 1
        }
        UserDefaults.standard.set(numLaunches, forKey: "numLaunches")
    }
    
    func showRateMe() {
        let alert = UIAlertController(title: NSLocalizedString("Rate_us_title", comment: "Rate Us"), message: NSLocalizedString("Rate_us_msg", comment: "Thanks for using Dream Notes\nWe hope you have sweet dreams"), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("No-thx", comment: "No Thanks"), style: UIAlertActionStyle.default, handler: {
            alertAction in
            UserDefaults.standard.set(true, forKey: "neverRate")
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Maybe", comment: "Maybe Later"), style: UIAlertActionStyle.default, handler: { alertAction in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Rate", comment: "Rate Dream Notes!"), style: UIAlertActionStyle.default, handler: { alertAction in
            UIApplication.shared.openURL(NSURL(string : "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=949218227&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8")! as URL)
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeALog(notification:NSNotification){
        //Make a log when dismissed the Notificaition
        print("NO - Dismissed Notification Pressed")
        
    }
    
    func redirectToEditor(notification:NSNotification){
        print("Note - Pressed")
        
        //Redirect to DreamEditorViewController when Notification is pressed
        self.performSegue(withIdentifier: "create", sender: self)
        
        func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
            if segue.identifier == "create" {
                _ = segue.destination as! DreamEditorViewController
            }
        }
    }
    
    func preferredContentSizeChanged(notification: NSNotification) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let dreamController:DreamUpdaterViewController = segue.destination as! DreamUpdaterViewController
            let dream:Dreams = fetchedResultController.object(at: indexPath!) as! Dreams
            dreamController.dream = dream
        }
        
        if segue.identifier == "config"{
            let _:SetNotificationViewController = segue.destination as! SetNotificationViewController
        }
    }
    
    func getFetchedResultController() -> NSFetchedResultsController<NSFetchRequestResult> {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest() , managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dreams")
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultController.sections?.count
        return numberOfSections!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        let dream = fetchedResultController.object(at: indexPath as IndexPath) as! Dreams
        
        
        if(indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.clear
        }else{
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            //cell.textLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        }
        
        //cell.textLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.desc.text = dream.title
        cell.data.text = dream.data
        return cell
    }
    
    //Delete
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject:NSManagedObject = fetchedResultController.object(at: indexPath as IndexPath) as! NSManagedObject
        managedObjectContext?.delete(managedObject)
        do{
            try managedObjectContext?.save()
        }catch{
            print("NÃO SALVO")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
