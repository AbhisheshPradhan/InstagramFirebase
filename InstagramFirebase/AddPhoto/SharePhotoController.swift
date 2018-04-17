//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Abhishesh Pradhan on 15/4/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController
{
    
    //selectedImage variable of this class set from header image from PhotoSelectorController class
    //then set the imageView's image as that selectedImage
    var selectedImage: UIImage? {
        didSet{
            self.imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        setupImageAndTextViews()
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .white
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.clipsToBounds = true
        return tv
    }()
    
    fileprivate func setupImageAndTextViews(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        //topLayoutGuide = navigation bar in this case
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 100)
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor,  paddingTop: 8, paddingLeft: 8, paddingBot: 8, width: 84)
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBot: 8, paddingRight: 8)
    }
    
    
    //upload the selected image into the storage
    @objc func handleShare(){
        
        guard let image = selectedImage else { return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
        
        //disable share button when it is pressed once
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                //if error in uploading file, enable share button again
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image:", err)
                return
            }
            
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
            
            print("Successfully uploaded post image:", imageUrl)
            
            
            //after upload get the imageurl then pass to database saver
            self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            
        }
    }
    
    
    //static = allows to be called outside from class..make it global value..
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    //save the imageurl, caption, etc in the database
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String){
        guard let postImage = selectedImage else { return }
        //guard let caption = textView.text else { return }
        let caption = textView.text ?? ""
        
        //user id of current logged in user
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        
        //database reference for the generated location
        let ref = userPostRef.childByAutoId()
        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err{
                //if err, enable share button again
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to Database", err)
                return
            }
            print("Successfully saved post to Database")
            
            //after success, dismiss the scene
            self.dismiss(animated: true, completion: nil)
            
            
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
