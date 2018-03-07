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
        
    }

    @IBAction func saveArticle(_ sender: Any) {
        let image = UIImageJPEGRepresentation(self.uploadImageView.image!, 1)
        articleAddViewModel?.saveArticle(articleViewModel: ArticleViewModel(title: titleTextField.text!, description: descTextView.text, created_date: "", image: ""), image: image!)
        navigationController?.popViewController(animated: true)
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

