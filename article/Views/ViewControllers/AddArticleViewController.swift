//
//  AddArticleViewController.swift
//  article
//
//  Created by Safhone on 3/6/18.
//  Copyright © 2018 Safhone. All rights reserved.
//

import UIKit
import Photos

class AddArticleViewController: UIViewController {

    var articleAddViewModel :ArticleAddViewModel?
    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleAddViewModel = ArticleAddViewModel()
        
        checkPhotoLibraryPermission()
        imagePicker.delegate = self
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageTapGesture.delegate = self
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.addGestureRecognizer(imageTapGesture)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShowForResizing), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideForResizing), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }

    @IBAction func saveArticle(_ sender: Any) {
        let image = UIImageJPEGRepresentation(self.uploadImageView.image!, 1)
        
        articleAddViewModel?.uploadArticle(image: image!) {
            self.articleAddViewModel?.saveArticle(articleViewModel: ArticleViewModel(title: self.titleTextField.text!, description: self.descTextView.text, created_date: "", image: (self.articleAddViewModel?.imageName)!))
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: window.origin.y + window.height - keyboardSize.height)
        }
    }
    
    @objc func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: viewHeight + keyboardSize.height)
        }
    }
    
}

extension AddArticleViewController: UIGestureRecognizerDelegate {
    @objc func imageTapped(tap: UITapGestureRecognizer) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        present(self.imagePicker, animated: true, completion: nil)
    }
}

extension AddArticleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func checkPhotoLibraryPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                }
            })
            print("It is not determined until now")
        case .restricted:
            print("User do not have access to photo album.")
        case .denied:
            print("User has denied the permission.")
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.uploadImageView.image = pickedImage
        } else{
            print("Something went wrong")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

