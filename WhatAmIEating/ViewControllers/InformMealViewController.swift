//
//  InformMealViewController.swift
//  WhatAmIEating
//
//  Created by Bárbara Ferreira on 08/04/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class InformMealViewController: UIViewController  {
    
    var meals: [Meal] = [ ]
    var mealTypes = [ "BREAKFAST", "LUNCH", "SNACK", "DINNER" ]
    var mealType: String = ""
    
    @IBOutlet weak var tt_page: UIImageView!
    
    @IBAction func logOut(_ sender: Any) {
        
        let authentication = Auth.auth()
        
        do{
            try authentication.signOut()
            self.performSegue(withIdentifier: "backTo", sender: self)
            dismiss(animated: true, completion: nil)
        } catch {
            print("Error while trying to log user out!")
        }
    }
    
    @IBAction func breakfastOption(_ sender: Any) {
        self.mealType = "BREAKFAST" //mealTypes[0]
        //createMeal(mealType: mealType)
    }
    
    @IBAction func lunchOption(_ sender: Any) {
        self.mealType = "LUNCH" //mealTypes[1]
        //createMeal(mealType: mealType)
    }
    
    @IBAction func snackOption(_ sender: Any) {
        self.mealType = "SNACK"
    }
    
    @IBAction func dinnerOption(_ sender: Any) {
        self.mealType = "DINNER" //mealTypes[3]
        //createMeal(mealType: mealType)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mealType = "SNACK"
        
        self.tt_page.image = #imageLiteral(resourceName: "add meal")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "breakfastType" || segue.identifier == "lunchType" || segue.identifier == "dinnerType" || segue.identifier == "snackType" {
            let photoMealViewController = segue.destination as! PhotoViewController
            photoMealViewController.mealType = self.mealType 
        }
    }
    
}

