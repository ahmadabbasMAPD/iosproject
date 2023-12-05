//
//  GuestProfileDetailsViewController.swift
//  MAPD_714_Project
//
//  Created by Jeet Panchal on 2023-12-03.
//

import UIKit

class GuestProfileDetailsViewController: UIViewController {

    @IBOutlet weak var DisplayGuestName: UILabel!
    @IBOutlet weak var DisplayGuestAddress: UILabel!
    @IBOutlet weak var DisplayGuestCity: UILabel!
    @IBOutlet weak var DisplayGuestCountry: UILabel!
    @IBOutlet weak var DisplayGuestPhoneNo: UILabel!
    @IBOutlet weak var DisplayGuestEmail: UILabel!
    @IBOutlet weak var DisplayGuestPassword: UILabel!
    
    // Database Manager instance
        let databaseManager = DatabaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch and display most recent GuestLogin data
                if let guestLoginData = databaseManager.getMostRecentUserData(tableName: "GuestLogin") {
                    print("GuestLogin Data: \(guestLoginData)")
                    DisplayGuestName.text = "\(guestLoginData["name"] ?? "")"
                    DisplayGuestAddress.text = "\(guestLoginData["address"] ?? "")"
                    DisplayGuestCity.text = "\(guestLoginData["city"] ?? "")"
                    DisplayGuestCountry.text = "\(guestLoginData["country"] ?? "")"
                    DisplayGuestPhoneNo.text = "\(guestLoginData["phone"] ?? "")"
                    DisplayGuestEmail.text = "\(guestLoginData["email"] ?? "")"
                    DisplayGuestPassword.text = "\(guestLoginData["password"] ?? "")"
                } else {
                    // Handle the case where no data is found
                    print("No recent data found for GuestLogin")
                }
    }
    
    @IBAction func UpdateGuestProfileBtnTapped(_ sender: Any) {
    }
    
    @IBAction func BookCruiseBtnTapped(_ sender: Any) {
    }
}
