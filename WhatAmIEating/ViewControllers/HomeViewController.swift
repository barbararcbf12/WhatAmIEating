//
//  HomeViewController.swift
//  WhatAmIEating
//
//  Created by Bárbara Ferreira on 31/03/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var mealsList: [Meal] = []
    
    
    @IBAction func logOutUser(_ sender: Any) {
        
        let authentication = Auth.auth()
        
        do{
            try authentication.signOut()
            self.performSegue(withIdentifier: "backToLogIn", sender: self)
            dismiss(animated: true, completion: nil)
//            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            
//            // save the presenting ViewController
//            let presentingViewController = window.rootViewController as! ViewController
//
//            self.dismiss(animated: true) {
//                // go back to MainMenuView as the eyes of the user
//                presentingViewController.dismiss(animated: true, completion: nil)
//            }
            
//            window.ViewController.dismiss(animated: true, completion: nil)
            
//            dismiss(animated: true) {
//            let logInPage = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
//            let appDelegate = UIApplication.shared.delegate
//            appDelegate?.window??.rootViewController = logInPage
//            }
//            try authentication.signOut()
//            dismiss(animated: true, completion: nil)
        } catch {
            print("Error while trying to log user out!")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //removing lines between table cells
        self.tableView.separatorStyle = .none
        
        //It was already done on the interface
            self.tableView.delegate = self
            self.tableView.dataSource = self
        
        //retrieve logged user
        let authentication = Auth.auth()
        if let idLoggedUser = authentication.currentUser?.uid {
            let database = Database.database().reference()
            let users = database.child("users")
            let meals = users.child( idLoggedUser ).child("meals")
            
            //adding an event to monitor when Meals are ADDED
            meals.observe(DataEventType.childAdded, with: { (snapshot) in
//                print(snapshot)
                
                //creating object meal
                let data = snapshot.value as? NSDictionary
//                data?.reversed()
                let meal = Meal()
                meal.id = snapshot.key
                meal.date = data?["date"] as! String
                meal.type = data?["type"] as! String
                meal.descriptionImage = data?["descriptionImage"] as! String
                meal.idImage = data?["idImage"] as! String
                meal.urlImage = data?["urlImage"] as! String
                
                self.mealsList.append( meal )
                
                //ORDERING LIST FROM MOST RECENT TO OLDEST
                //self.mealsList.reverse()
                self.mealsList.sort(){$0.date > $1.date}
                
                //print(self.mealsList)
                self.tableView.reloadData()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let totalMeals = mealsList.count
        
        if totalMeals == 0 {
            return 1
        }
        
        return totalMeals
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Creating a var and attributing the identifier of the TableView
        let cellReuse = "cellReuse"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuse, for: indexPath) as! CellMeal
        
        let totalMeals = self.mealsList.count
//        print(totalMeals)
        
        if totalMeals == 0 {
            
//            cell.textLabel?.text = "You have no meals."
//            cell.cellPlaceholder.text = "You have no meals."
            cell.cellMealType.text = "You have no meals!"
            cell.cellMealDescription.text = ""
            
        }else {
            
            let meal = mealsList[ indexPath.row ]
            let url = URL( string: meal.urlImage )
//            cell.cellPlaceholder.text = ""
            
            // Configuring the cell...
            cell.cellImageView.sd_setImage( with: url )
            cell.cellMealType.text = meal.type 
            cell.cellMealDescription.text = meal.date
//            cell.textLabel?.text = meal.urlImage
            
            cell.cellImageView.layer.cornerRadius = 35
            cell.cellImageView.clipsToBounds = true
            
            let borderColor : UIColor = UIColor(red: 0.275, green: 0.580, blue: 0.776, alpha: 1.0)
            cell.cellImageView.layer.borderWidth = 3
            cell.cellImageView.layer.borderColor = borderColor.cgColor
            
            cell.contentView.layoutMargins = UIEdgeInsets.zero //UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        }
        
        return cell
        
    }
    
    //sending MEAL object to Details view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let totalMeals = mealsList.count
        if totalMeals > 0 {
            let meal = self.mealsList[ indexPath.row ]
            self.performSegue( withIdentifier: "detailsMealSegue", sender: meal )
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsMealSegue" {
            let detailsMealViewController = segue.destination as! DetailsMealViewController
            detailsMealViewController.meal = sender as! Meal
        }
    }

}

