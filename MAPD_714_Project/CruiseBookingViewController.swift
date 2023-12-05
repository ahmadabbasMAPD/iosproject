//
//  CruiseBookingViewController.swift
//  MAPD_714_Project
//
//  Created by Jeet Panchal on 2023-12-03.
//

import UIKit

class CruiseBookingViewController: UIViewController {

    @IBOutlet weak var BookingDetails: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Display user information
                if let mostRecentUserData = DatabaseManager.shared.getMostRecentUserData(tableName: "NewUserLogin") {
                    displayUserData(userData: mostRecentUserData)
                }

                // Display cruise data
                if let mostRecentCruiseData = DatabaseManager.shared.getMostRecentCruiseSelectedData() {
                    displayCruiseData(cruiseData: mostRecentCruiseData)
                }

                // Display guest data
                if let mostRecentGuestData = DatabaseManager.shared.getMostRecentGuestInformationSelectedData() {
                    displayGuestData(guestData: mostRecentGuestData)
                }
            }

            func displayUserData(userData: [String: Any]) {
                // Extract relevant information from userData dictionary
                let name = userData["name"] as? String ?? ""
                let phone = userData["phone"] as? String ?? ""

                // Combine the user information into a single string
                let userInfo = """
                User Information:
                Name: \(name)
                Phone: \(phone)
                """

                // Set the combined information to the BookingDetails label
                BookingDetails.text = userInfo
            }

            func displayCruiseData(cruiseData: [String: Any]) {
                // Extract relevant information from cruiseData dictionary
                let cruiseName = cruiseData["cruiseName"] as? String ?? ""
                let price = cruiseData["price"] as? String ?? ""

                // Combine the cruise information into a single string
                let cruiseInfo = """
                Cruise Information:
                Cruise Name: \(cruiseName)
                Price: \(price)
                """

                // Append the cruise information to the BookingDetails label
                BookingDetails.text?.append("\n\n\(cruiseInfo)")
            }

    func displayGuestData(guestData: [String: Any]) {
        // Extract relevant information from guestData dictionary
        if let adultsString = guestData["adults"] as? String, let adults = Int(adultsString),
           let kidsString = guestData["kids"] as? String, let kids = Int(kidsString),
           let seniorsString = guestData["seniors"] as? String, let seniors = Int(seniorsString) {

            // Combine the guest information into a single string
            let guestInfo = """
            Guest Information:
            Adults: \(adults)
            Kids: \(kids)
            Seniors: \(seniors)
            """

            // Append the guest information to the ReservationDetails label
            BookingDetails.text?.append("\n\n\(guestInfo)")
            } else {
                print("Error converting guest data to integers")
            }
        }
}
    
