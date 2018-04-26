//
//  GalleryViewController.swift
//  WhatAmIEating
//
//  Created by Bárbara Ferreira on 31/03/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var visualizations: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var meals: [Meal] = []
    var mealTypes: [String] = [ "Breakfast", "Lunch", "Snack", "Dinner", "Supper", "Other"]
    
    @IBAction func logOutUser(_ sender: Any) {
        
        let authentication = Auth.auth()
        
        do{
            try authentication.signOut()
            self.performSegue(withIdentifier: "LogIn", sender: self)
            dismiss(animated: true, completion: nil)
        } catch {
            print("Error while trying to log user out!")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.visualizations.image = #imageLiteral(resourceName: "map_view")
        //removing lines between table cells
//        self.tableView.separatorStyle = .none
//
//        //It was already done on the interface
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        
        //retrieve logged user
//        let authentication = Auth.auth()
//        if let idLoggedUser = authentication.currentUser?.uid {
//            let database = Database.database().reference()
//            let users = database.child("users")
//            let meals = users.child( idLoggedUser ).child("meals")
//
//            //adding an event to monitor when Snaps are ADDED
//            meals.observe(DataEventType.childAdded, with: { (snapshot) in
//                //print(snapshot)
//
//                //creating object snap
//                let data = snapshot.value as? NSDictionary
//                let meal = Meal()
//                meal.id = snapshot.key
//                meal.date = data?["date"] as! String
//                meal.type = data?["type"] as! String
//                meal.descriptionImage = data?["descriptionImage"] as! String
//                meal.idImage = data?["idImage"] as! String
//                meal.urlImage = data?["urlImage"] as! String
//
//                self.meals.append( meal )
//                //print(self.snaps)
//                self.tableView.reloadData()
//            })
        
    
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let totalMeals = meals.count
//        if totalMeals == 0 {
//            return 1
//        }
//        return totalMeals
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMeal", for: indexPath)
//
//        let totalMeals = meals.count
//        if totalMeals == 0 {
//            cell.textLabel?.text = "You have no meal."
//        }else {
//            let meal = self.meals[ indexPath.row ]
//            cell.textLabel?.text = meal.type
//        }
//
//        return cell
//
//    }
//
//    //sending snap object to Details view
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let totalMeals = meals.count
//        if totalMeals > 0 {
//            let meal = self.meals[ indexPath.row ]
//            self.performSegue( withIdentifier: "detailsSnapSegue", sender: meal )
//        }
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "detailsMealSegue" {
//            let detailsMealViewController = segue.destination as! DetailsMealViewController
//            detailsMealViewController.meal = sender as! Meal
//        }
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

