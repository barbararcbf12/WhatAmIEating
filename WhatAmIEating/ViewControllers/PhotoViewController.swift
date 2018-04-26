//
//  PhotoViewController.swift
//  WhatAmIEating
//
//  Created by Bárbara Ferreira on 31/03/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import Photos

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    var button   = UIButton(type: UIButtonType.custom) as UIButton
    var mealType: String = "SNACK"
    var imagePicker = UIImagePickerController()
    var idImage = NSUUID().uuidString //generating an unique id to the images per session
    
    var documentController: UIDocumentInteractionController!
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nextShow: UIButton!
    @IBOutlet weak var labelPicture: UITextView!
    
    @IBOutlet weak var saveButtonIcon: UIButton!
    
    @IBAction func saveAndShareText(_ sender: Any) {
        self.saveButtonIcon.isEnabled = false
        self.saveButtonIcon.setTitle("Loading...", for: .normal)
        self.retrieveAndShareImage()
        self.countSharing()
    }
    
    @IBAction func saveAndShareIcon(_ sender: Any) {
        self.saveButtonIcon.isEnabled = false
        self.saveButtonIcon.setTitle("Loading...", for: .normal)
        self.retrieveAndShareImage()
        self.countSharing()
    }
    
    @IBAction func saveButtonScene(_ sender: Any) {
        self.nextShow.isEnabled = false
        self.nextShow.setTitle("Loading...", for: .normal)
        self.retrieveImage()
    }
    
    func retrieveAndShareImage(){
        let storage = Storage.storage().reference()
        let images = storage.child("images") //create images folder
        
        //retrieve image
        if let selectedImage = picture.image {
            //converting the image to data
            if let imageData = UIImageJPEGRepresentation(selectedImage, 0.1) {
                images.child("\(self.idImage).jpg").putData(imageData, metadata: nil, completion: { ( metaDados, error ) in
                    
                    if error == nil {
                        
                        //                        let dateFormatterGet = DateFormatter()
                        //                        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        //
                        //                        let dateFormatter = DateFormatter()
                        //                        dateFormatter.dateFormat = "MMM dd, HH:mm"
                        //
                        //                        let date: Date? = dateFormatterGet.date(from: "2017-02-14 17:24:26")
                        //
                        //                        let createdDate = dateFormatter.string(from: date!)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM dd"
                        
                        let createdDate = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.short)
                        
                        //get picture url
                        let urlPicture = metaDados?.downloadURL()?.absoluteString
                        
                        //Enabling SHARE button
                        self.saveButtonIcon.isEnabled = true
                        
                        self.createAndShareMeal(mealType: self.mealType, urlPicture: urlPicture!, date: createdDate)
                        self.performSegue(withIdentifier: "backHome", sender: nil)
                        
                    }else {
                        //print("Failure!")
                        let alert = Alert(title: "Upload filed!", msg: "Error while trying to upload picture, plase try again")
                        self.present( alert.getAlert(), animated: true, completion: nil )
                    }
                })
            }
        }
    }
    
    func retrieveImage(){
        let storage = Storage.storage().reference()
        let images = storage.child("images") //create images folder
        
        //retrieve image
        if let selectedImage = picture.image {
            //converting the image to data
            if let imageData = UIImageJPEGRepresentation(selectedImage, 0.1) {
                images.child("\(self.idImage).jpg").putData(imageData, metadata: nil, completion: { ( metaDados, error ) in
                    
                    if error == nil {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM dd"
                        
                        let createdDate = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.short)
                        
                        //get picture url
                        let urlPicture = metaDados?.downloadURL()?.absoluteString
                        
                        //Enabling SAVE button
                        self.nextShow.isEnabled = true
                        //self.nextShow.setTitle("Next", for: .normal)
                        
                        self.createMeal(mealType: self.mealType, urlPicture: urlPicture!, date: createdDate)
                        self.performSegue(withIdentifier: "backHome", sender: nil)
                        
                    }else {
                        let alert = Alert(title: "Upload filed!", msg: "Error while trying to upload picture, plase try again")
                        self.present( alert.getAlert(), animated: true, completion: nil )
                    }
                })
            }
        }
    }
    
    func createAndShareMeal(mealType: String, urlPicture: String, date: String) {
        //retrieve logged user
        let authentication = Auth.auth()
        if let idLoggedUser = authentication.currentUser?.uid {
            //print(idLoggedUser)
            let database = Database.database().reference()
            let users = database.child("users")
            let meals = users.child( idLoggedUser ).child("meals")
            
            let meal = [
                "type": self.mealType,
                "descriptionImage": self.labelPicture.text!,
                "idImage": self.idImage,
                "urlImage": urlPicture,
                "date": date,
                ]
            
            meals.childByAutoId().setValue( meal ) //creating an unique id for each meal
            
            //Sharing on Instagram
            SocialShare.shared.postImageToInstagram(image: self.picture.image!)
        }
    }
    
    func createMeal(mealType: String, urlPicture: String, date: String) {
        //retrieve logged user
        let authentication = Auth.auth()
        if let idLoggedUser = authentication.currentUser?.uid {
            //print(idLoggedUser)
            let database = Database.database().reference()
            let users = database.child("users")
            let meals = users.child( idLoggedUser ).child("meals")
            
            let meal = [
                "type": self.mealType,
                "descriptionImage": self.labelPicture.text!,
                "idImage": self.idImage,
                "urlImage": urlPicture,
                "date": date,
                ]
            
            meals.childByAutoId().setValue( meal ) //creating an unique id for each meal
        }
    }
    
    @IBAction func takePhotoButton(_ sender: Any) {
        imagePicker.sourceType = .camera //take picture
        present( imagePicker, animated: true, completion: nil )
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker.sourceType = .camera //take picture
        present( imagePicker, animated: true, completion: nil )
    }
    
    @IBAction func chosePhoto(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum //select from gallery
        present( imagePicker, animated: true, completion: nil )
    }
    
    //Closing keyboard when clicking/tapping outside textbox
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //print(info)
        let retrievedPicture = info[ UIImagePickerControllerOriginalImage ] as! UIImage
        picture.image = retrievedPicture
        
        //enable button SAVE
        self.nextShow.isEnabled = true
        self.nextShow.backgroundColor = UIColor( red: 0.271, green: 0.576, blue: 0.773, alpha: 1 )
        
        //enable button SHARE
        self.saveButtonIcon.isEnabled = true
        self.saveButtonIcon.backgroundColor = UIColor( red: 0.553, green: 0.369, blue: 0.749, alpha: 1 )
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(mealType)
        
        imagePicker.delegate = self
        
        //disable buttons SAVE & SHARE
        nextShow.isEnabled = false
        nextShow.backgroundColor = UIColor.gray
        saveButtonIcon.isEnabled = false
        saveButtonIcon.backgroundColor = UIColor.gray
        
        //adding border & rounded corners to text field
        labelPicture!.layer.borderWidth = 0.5
        labelPicture!.layer.borderColor = UIColor.lightGray.cgColor
        labelPicture.layer.cornerRadius = 5
        labelPicture.clipsToBounds = true
        
        //adding border & rounded corners to picture
        picture.layer.cornerRadius = 10
        picture.clipsToBounds = true
        picture.layer.borderWidth = 0.5
        picture.layer.borderColor = UIColor.lightGray.cgColor
    
        //adding rounded corners to SAVE and SHARE buttons
        nextShow.layer.cornerRadius = 5
        nextShow.clipsToBounds = true
        saveButtonIcon.layer.cornerRadius = 5
        saveButtonIcon.clipsToBounds = true
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func countSharing(){
        
        //retrieve logged user
        let authentication = Auth.auth()
        if let idLoggedUser = authentication.currentUser?.uid {
            //print(idLoggedUser)
            let database = Database.database().reference()
            let users = database.child("users")
            
            let shareFromPhoto = users.child( idLoggedUser ).child("shareFromPhoto")
//            let shareFromDetails = users.child( idLoggedUser ).child("shareFromDetails")
            
            shareFromPhoto.childByAutoId().setValue( 1 ) //creating an unique id for each meal
            
        }
    }
    
}

