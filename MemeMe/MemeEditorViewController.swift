//
//  ViewController.swift
//  MemeMe
//
//  Created by Carlos Lozano on 8/10/17.
//  Copyright © 2017 Carlos Lozano. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var botomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField(topTextField, desfaultText: "TOP")
        configureTextField(botomTextField, desfaultText: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topTextField.textAlignment = .center
        botomTextField.textAlignment = .center
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    // MARK: barsAreVisible
    // Method for hiding or displaying the navigation bar and the toolbar
    func barsAreHidden (barsAreHidden: Bool){
        navigationController?.navigationBar.isHidden = barsAreHidden
        toolBar.isHidden = barsAreHidden
    }
    
    
    func configureTextField(_ textField: UITextField, desfaultText: String){
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: NSNumber(value: -3)
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = UITextBorderStyle.none
        textField.text = desfaultText
        textField.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func keyboardWillShow(_ notification:Notification) {
        if !(topTextField.isEditing){
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide (_ notification:Notification){
        view.frame.origin.y = 0
    }
    
    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
        
        
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func generateMemedImage() -> UIImage {
        
        barsAreHidden(barsAreHidden: true)
       
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        barsAreHidden(barsAreHidden: false)
        
        
        return memedImage
    }
    
    
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    func pickImageFrom(_ source: UIImagePickerControllerSourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    func save(memedImage: UIImage){
        print (self.topTextField.text ?? "")
        
        print (self.botomTextField.text!)
        
        
        let meme = Meme(topText: self.topTextField.text!, botomText: self.botomTextField.text!, originalImage: self.imageView.image!, memedImage:memedImage)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }

    
    @IBAction func dissmissEditor(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickImage(_ sender: Any) {
        pickImageFrom(.photoLibrary)
    }
    
    @IBAction func takeImage(_ sender: Any) {
        pickImageFrom(.camera)
    }
    
    @IBAction func share(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        
       let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities:nil)
        
        activityController.completionWithItemsHandler = {(activityType: UIActivityType?, shared: Bool, items: [Any]?, error: Error?)  in
            if shared {
                
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.append( Meme(topText: self.topTextField.text!, botomText: self.botomTextField.text!, originalImage: self.imageView.image, memedImage: memedImage))
                
                
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        present(activityController, animated: true, completion:nil)
    }
    
    
}

