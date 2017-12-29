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
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
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
        txtDesc.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        self.navigationItem.title = "✏️📓💭"
        configureTextView()
        
        //receive notifications when the preferred content size changes
        NotificationCenter.default.addObserver(self,
            selector: #selector(DreamUpdaterViewController.preferredContentSizeChanged(_:)),
            name: NSNotification.Name.UIContentSizeCategoryDidChange,
            object: nil)
        
        //Get text and date from db
        if dream != nil {
            txtDesc.text = dream?.texto
        }
        if let data = showData {
            data.text = dream?.data
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Listen for changes to keyboard visibility so that we can adjust the text view accordingly.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(DreamUpdaterViewController.handleKeyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(DreamUpdaterViewController.handleKeyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Keyboard Event Notifications
    
    @objc func handleKeyboardWillShowNotification(_ notification: Notification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: true)
    }
    
    @objc func handleKeyboardWillHideNotification(_ notification: Notification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: false)
    }
    
    func keyboardWillChangeFrameWithNotification(_ notification: Notification, showsKeyboard: Bool) {
        let userInfo = notification.userInfo!
        
        let animationDuration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        // Convert the keyboard frame from screen to view coordinates.
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardViewBeginFrame = view.convert(keyboardScreenBeginFrame, from: view.window)
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        
        // The text view should be adjusted, update the constant for this constraint.
        textViewBottomLayoutGuideConstraint.constant -= originDelta
        
        view.setNeedsUpdateConstraints()
        
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .beginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        // Scroll to the selected text once the keyboard frame changes.
        let selectedRange = txtDesc.selectedRange
        txtDesc.scrollRangeToVisible(selectedRange)
    }
    
    // MARK: Configuration
    
    func configureTextView() {
        
        let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body)
        txtDesc.font = UIFont(descriptor: bodyFontDescriptor, size: 0)
        
        txtDesc.textColor = UIColor.black
        txtDesc.backgroundColor = UIColor.white
        txtDesc.isScrollEnabled = true
        
        // Let's modify some of the attributes of the attributed string.
        // You can modify these attributes yourself to get a better feel for what they do.
        // Note that the initial text is visible in the storyboard.
        let attributedText = NSMutableAttributedString(attributedString: txtDesc.attributedText!)
        
        // Use NSString so the result of rangeOfString is an NSRange, not Range<String.Index>.
        let text = txtDesc.text! as NSString
        
        // Find the range of each element to modify.
        let boldRange = text.range(of: NSLocalizedString("bold", comment: ""))
        let highlightedRange = text.range(of: NSLocalizedString("highlighted", comment: ""))
        let underlinedRange = text.range(of: NSLocalizedString("underlined", comment: ""))
        let tintedRange = text.range(of: NSLocalizedString("tinted", comment: ""))
        
        // Add bold. Take the current font descriptor and create a new font descriptor with an additional bold trait.
        let boldFontDescriptor = txtDesc.font!.fontDescriptor.withSymbolicTraits(.traitBold)
        let boldFont = UIFont(descriptor: boldFontDescriptor!, size: 0)
        attributedText.addAttribute(NSAttributedStringKey.font, value: boldFont, range: boldRange)
        
        // Add highlight.
        attributedText.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.red, range: highlightedRange)
        
        // Add underline.
        attributedText.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: underlinedRange)
        
        // Add tint.
        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: tintedRange)
        
        txtDesc.attributedText = attributedText
    }
    
    
    // MARK: Accessibility Notification
    
    @objc func preferredContentSizeChanged(_ notification: Notification) {
        txtDesc.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    }
    
    
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismissViewController()
    }
    
    @IBAction func save(_ sender: AnyObject) {
        if dream != nil {
            if txtDesc.text == "" {
                if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
                    //Show a Message in iOS 8
                    let alert = UIAlertController(title: NSLocalizedString("Alert_title", comment: "Warning"), message: NSLocalizedString("Alert_msg", comment: "Insert text for your dream..."),preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    //Show a Message in iOS 7
                    let alert = UIAlertView()
                    alert.title = NSLocalizedString("Alert_title", comment: "Warning")
                    alert.message = NSLocalizedString("Alert_msg", comment: "Insert text for your dream...")
                    alert.addButton(withTitle: "OK")
                    alert.show()
                }
            }else{
                editDream()
                dismissViewController()
            }
        }
    }
    
    func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func editDream() {
        dream?.texto = txtDesc.text
        do {
            try managedObjectContext?.save()
        }catch {
            print("NÃO SALVO")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "share"{
            let vc:ShareVC = segue.destination as! ShareVC
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