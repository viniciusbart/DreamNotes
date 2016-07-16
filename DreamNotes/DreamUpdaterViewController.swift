//
//  DreamUpdaterViewController.swift
//  DreamNotes
//
//  Created by Vinícius Bazanelli on 02/10/14.
//  Copyright (c) 2014 Baza Inc. All rights reserved.
//

import UIKit
import CoreData

class DreamUpdaterViewController: UIViewController, UITextViewDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var firstEdit = 1
    var viewHeightFull:CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    
    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet weak var showData: UITextField!
    /// Used to adjust the text view's height when the keyboard hides and shows.
    @IBOutlet weak var textViewBottomLayoutGuideConstraint: NSLayoutConstraint!
    
    
    var dream: Dreams? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Handling Accessibility
        //txtDesc.scrollEnabled = true
        txtDesc.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        self.navigationItem.title = "✏️📓💭"
        configureTextView()
        
        //receive notifications when the preferred content size changes
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "preferredContentSizeChanged:",
            name: UIContentSizeCategoryDidChangeNotification,
            object: nil)
        
        //Get text and date from db
        if dream != nil {
            txtDesc.text = dream?.texto
        }
        if let data = showData {
            data.text = dream?.data
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Listen for changes to keyboard visibility so that we can adjust the text view accordingly.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: Keyboard Event Notifications
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: true)
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: false)
    }
    
    func keyboardWillChangeFrameWithNotification(notification: NSNotification, showsKeyboard: Bool) {
        let userInfo = notification.userInfo!
        
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        // Convert the keyboard frame from screen to view coordinates.
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        
        // The text view should be adjusted, update the constant for this constraint.
        textViewBottomLayoutGuideConstraint.constant -= originDelta
        
        view.setNeedsUpdateConstraints()
        
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        // Scroll to the selected text once the keyboard frame changes.
        let selectedRange = txtDesc.selectedRange
        txtDesc.scrollRangeToVisible(selectedRange)
    }
    
    // MARK: Configuration
    
    func configureTextView() {
        
        let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
        txtDesc.font = UIFont(descriptor: bodyFontDescriptor, size: 0)
        
        txtDesc.textColor = UIColor.blackColor()
        txtDesc.backgroundColor = UIColor.whiteColor()
        txtDesc.scrollEnabled = true
        
        // Let's modify some of the attributes of the attributed string.
        // You can modify these attributes yourself to get a better feel for what they do.
        // Note that the initial text is visible in the storyboard.
        let attributedText = NSMutableAttributedString(attributedString: txtDesc.attributedText!)
        
        // Use NSString so the result of rangeOfString is an NSRange, not Range<String.Index>.
        let text = txtDesc.text! as NSString
        
        // Find the range of each element to modify.
        let boldRange = text.rangeOfString(NSLocalizedString("bold", comment: ""))
        let highlightedRange = text.rangeOfString(NSLocalizedString("highlighted", comment: ""))
        let underlinedRange = text.rangeOfString(NSLocalizedString("underlined", comment: ""))
        let tintedRange = text.rangeOfString(NSLocalizedString("tinted", comment: ""))
        
        // Add bold. Take the current font descriptor and create a new font descriptor with an additional bold trait.
        let boldFontDescriptor = txtDesc.font!.fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitBold)
        let boldFont = UIFont(descriptor: boldFontDescriptor, size: 0)
        attributedText.addAttribute(NSFontAttributeName, value: boldFont, range: boldRange)
        
        // Add highlight.
        attributedText.addAttribute(NSBackgroundColorAttributeName, value: UIColor.redColor(), range: highlightedRange)
        
        // Add underline.
        attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: underlinedRange)
        
        // Add tint.
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: tintedRange)
        
        txtDesc.attributedText = attributedText
    }
    
    
    // MARK: Accessibility Notification
    
    func preferredContentSizeChanged(notification: NSNotification) {
        txtDesc.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
    
    
    
    // MARK: Actions
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewController()
    }
    
    @IBAction func save(sender: AnyObject) {
        if dream != nil {
            if txtDesc.text == "" {
                if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
                    //Show a Message in iOS 8
                    let alert = UIAlertController(title: NSLocalizedString("Alert_title", comment: "Warning"), message: NSLocalizedString("Alert_msg", comment: "Insert text for your dream..."),preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }else{
                    //Show a Message in iOS 7
                    let alert = UIAlertView()
                    alert.title = NSLocalizedString("Alert_title", comment: "Warning")
                    alert.message = NSLocalizedString("Alert_msg", comment: "Insert text for your dream...")
                    alert.addButtonWithTitle("OK")
                    alert.show()
                }
            }else{
                editDream()
                dismissViewController()
            }
        }
    }
    
    func dismissViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func editDream() {
        dream?.texto = txtDesc.text
        do {
            try managedObjectContext?.save()
        }catch {
            print("NÃO SALVO")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "share"{
            let vc:ShareVC = segue.destinationViewController as! ShareVC
            editDream()
            vc.texto = txtDesc.text
            vc.data = showData.text!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
