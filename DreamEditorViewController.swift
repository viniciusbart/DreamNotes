//
//  DreamEditorViewController.swift
//  DreamNotes
//
//  Created by Vinícius Bazanelli on 01/10/14.
//  Copyright (c) 2014 Baza Inc. All rights reserved.
//

import UIKit
import CoreData

class DreamEditorViewController: UIViewController, UITextViewDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var firstEdit = true
    
    @IBOutlet weak var txtDesc: UITextView!
    /// Used to adjust the text view's height when the keyboard hides and shows.
    @IBOutlet weak var textViewBottomLayoutGuideConstraint: NSLayoutConstraint!
    
    var dream: Dreams? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Handling Accessibility
        txtDesc.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        txtDesc.text = NSLocalizedString("Body", comment: "Tell me your dream...")
        txtDesc.textColor = UIColor.lightGrayColor()
        
        configureTextView()
        
        //receive notifications when the preferred content size changes
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "preferredContentSizeChanged:",
            name: UIContentSizeCategoryDidChangeNotification,
            object: nil)
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
        textViewShouldBeginEditing(txtDesc)
        
        // Get information about the animation.
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        // Convert the keyboard frame from screen to view coordinates.
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        
        // The text view should be adjusted, update the constant for this constraint.
        textViewBottomLayoutGuideConstraint.constant -= originDelta
        
        // Inform the view that its autolayout constraints have changed and the layout should be updated.
        view.setNeedsUpdateConstraints()
        
        // Animate updating the view's layout by calling layoutIfNeeded inside a UIView animation block.
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        // Scroll to the selected text once the keyboard frame changes.
        let selectedRange = txtDesc.selectedRange
        txtDesc.scrollRangeToVisible(selectedRange)
        
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if self.view.window != nil {
            txtDesc.selectedTextRange = txtDesc.textRangeFromPosition(txtDesc.beginningOfDocument, toPosition: txtDesc.beginningOfDocument)
        }
    }
    
    
    func textViewShouldBeginEditing(txtDesc: UITextView) -> Bool {
        if txtDesc.text == NSLocalizedString("Body", comment: "Tell me your dream...") {
            txtDesc.text = nil
        }
        
        if txtDesc.textColor == UIColor.lightGrayColor() {
            txtDesc.textColor = UIColor.blackColor()
        }
        return true
    }
    
    
    // MARK: Configuration
    
    
    func configureTextView() {
        
        let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
        txtDesc.font = UIFont(descriptor: bodyFontDescriptor, size: 0)
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
        if dream == nil {
            if txtDesc.text == "" || txtDesc.text == NSLocalizedString("Body", comment: "Tell me your dream..."){
                if let _: AnyClass = NSClassFromString("UIAlertController") {
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
                createDream()
                dismissViewController()
            }
        }
    }
    
    func dismissViewController() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func getDateTime() -> String {
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .MediumStyle)
        return timestamp
    }
    
    func createDream() {
        let entityDescripition = NSEntityDescription.entityForName("Dreams", inManagedObjectContext: managedObjectContext!)
        let timeStamp = NSDate()
        let date = getDateTime()
        let drm = Dreams(entity: entityDescripition!, insertIntoManagedObjectContext: managedObjectContext)
        drm.texto = txtDesc.text
        drm.data = date
        drm.timestamp = timeStamp
        managedObjectContext
        do{
            try managedObjectContext?.save()
        }catch{
            fatalError("deu merda: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
