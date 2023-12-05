//
//  NewUserProfileDetailsViewController.swift
//  MAPD_714_Project
//
//  Created by Jeet Panchal on 2023-12-04.
//

import UIKit

class NewUserProfileDetailsViewController: UIViewController {

    
    @IBOutlet weak var DisplayNewUserName: UILabel!
    
    @IBOutlet weak var DisplayNewUserAddress: UILabel!
    
    @IBOutlet weak var DisplayNewUserCity: UILabel!
    
    @IBOutlet weak var DisplayNewUserCountry: UILabel!
    
    @IBOutlet weak var DisplayNewUserPhoneNo: UILabel!
    
    @IBOutlet weak var DisplayNewUserEmail: UILabel!
    
    @IBOutlet weak var DisplayNewUserPassword: UILabel!
    
    
    
    // Database Manager instance
        let databaseManager = DatabaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch and display most recent NewUserLogin data
                if let newUserLoginData = databaseManager.getMostRecentUserData(tableName: "NewUserLogin") {
                    print("NewUserLogin Data: \(newUserLoginData)")
                    DisplayNewUserName.text = "\(newUserLoginData["name"] ?? "")"
                    DisplayNewUserAddress.text = "\(newUserLoginData["address"] ?? "")"
                    DisplayNewUserCity.text = "\(newUserLoginData["city"] ?? "")"
                    DisplayNewUserCountry.text = "\(newUserLoginData["country"] ?? "")"
                    DisplayNewUserPhoneNo.text = "\(newUserLoginData["phone"] ?? "")"
                    DisplayNewUserEmail.text = "\(newUserLoginData["email"] ?? "")"
                    DisplayNewUserPassword.text = "\(newUserLoginData["password"] ?? "")"
                } else {
                    // Handle the case where no data is found
                    print("No recent data found for NewUserLogin")
                }
        }
}
