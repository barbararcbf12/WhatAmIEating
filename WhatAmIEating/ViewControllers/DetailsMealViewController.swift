//
//  DetailsMealViewController.swift
//  WhatAmIEating
//
//  Created by Bárbara Ferreira on 01/04/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class DetailsMealViewController: UIViewController {
    
    @IBOutlet weak var imageMeal: UIImageView!
    @IBOutlet weak var detailMeal: UILabel!
    @IBOutlet weak var typeMeal: UILabel!
    @IBOutlet weak var dateMeal: UILabel!
    
    
    @IBOutlet weak var saveButtonIcon: UIButton!
    @IBAction func saveAndShareButton(_ sender: Any) {
        let image = imageMeal.image
        SocialShare.shared.postImageToInstagram(image: image!)
        self.countSharing()
    }
    
    var meal = Meal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loading label
        detailMeal.text = "Loading..."
        
        //adding rounded corners to SHARE button
        saveButtonIcon.layer.cornerRadius = 5
        saveButtonIcon.clipsToBounds = true
        
        //getting image's URL and loading image
//        import SDWebImage
        let url = URL( string: meal.urlImage )
        imageMeal.sd_setImage( with: url ) { (image, error, cache, url) in
            
            //only after the image is loaded, the counter is started
            if error == nil {
            
                //getting and loading description
                self.typeMeal.text = self.meal.date
                self.detailMeal.text = self.meal.descriptionImage
                self.dateMeal.text = self.meal.type
                
            }
        }
        
        //adding border & rounded corners to picture
        imageMeal.layer.cornerRadius = 10
        imageMeal.clipsToBounds = true
        imageMeal.layer.borderWidth = 0.5
        imageMeal.layer.borderColor = UIColor.lightGray.cgColor
        
        
    }
    
    /*//excluding snap after closing the view
    override func viewWillDisappear(_ animated: Bool) {
        //print("View was closed!")
        
        //retrieving id of logged user
        let authentication = Auth.auth()
        
        if let idLoggedUser = authentication.currentUser?.uid {
            
            //removing node from database
            let database = Database.database().reference()
            let users = database.child("users")
            let meals = users.child(idLoggedUser).child("meals")
            
            meals.child(meal.id).removeValue()
            
            //removing snap's image from database
            let storage = Storage.storage().reference()
            let images = storage.child("images")
            
            images.child( "\(meal.idImage).jpg" ).delete(completion: { (error) in
                if error == nil {
                    print("Success on removing meal!")
                }else {
                    print("An error occured!")
                }
            })
        }
    }*/
    
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
            
//            let shareFromPhoto = users.child( idLoggedUser ).child("shareFromPhoto")
            let shareFromDetails = users.child( idLoggedUser ).child("shareFromDetails")
            
            shareFromDetails.childByAutoId().setValue( 1 ) //creating an unique id for each meal
            
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

