//
//  ReservationInformationViewController.swift
//  MAPD_714_Project
//
//  Created by Jeet Panchal on 2023-12-03.
//

import UIKit

class ReservationInformationViewController: UIViewController {

    var paymentType: String?
        var cardNumber: String?
        var cardHolderName: String?
        var expiryDate: String?

    @IBOutlet weak var ReservationDetails: UILabel!

        override func viewDidLoad() {
            super.viewDidLoad()

            // Combine the payment information into a single string
            let paymentInfo = """
            Payment Type: \(paymentType ?? "")
            Card Number: \(cardNumber ?? "")
            Card Holder Name: \(cardHolderName ?? "")
            Expiry Date: \(expiryDate ?? "")
            """

            // Set the combined information to the text field
            ReservationDetails.text = paymentInfo
            
            // Display most recent user data
                    if let mostRecentUserData = DatabaseManager.shared.getMostRecentUserData(tableName: "NewUserLogin") {
                        displayUserData(userData: mostRecentUserData)
                    }

                    // Display most recent cruise selected data
                    if let mostRecentCruiseData = DatabaseManager.shared.getMostRecentCruiseSelectedData() {
                        displayCruiseData(cruiseData: mostRecentCruiseData)
                    }

                    if let mostRecentGuestData = DatabaseManager.shared.getMostRecentGuestInformationSelectedData() {
                        print("Most Recent Guest Data: \(mostRecentGuestData)")
                        displayGuestData(guestData: mostRecentGuestData)
                    } else {
                        print("Error retrieving most recent guest data")
                    }

        }
    
    func displayUserData(userData: [String: Any]) {
            // Extract relevant information from userData dictionary
            let name = userData["name"] as? String ?? ""
            let address = userData["address"] as? String ?? ""
            let city = userData["city"] as? String ?? ""
            let country = userData["country"] as? String ?? ""
            let phone = userData["phone"] as? String ?? ""
            let email = userData["email"] as? String ?? ""

            // Combine the user information into a single string
            let userInfo = """
            User Information:
            Name: \(name)
            Address: \(address)
            City: \(city)
            Country: \(country)
            Phone: \(phone)
            Email: \(email)
            """

            // Append the user information to the ReservationDetails label
            ReservationDetails.text?.append("\n\n\(userInfo)")
        }

        func displayCruiseData(cruiseData: [String: Any]) {
            // Extract relevant information from cruiseData dictionary
            let cruiseName = cruiseData["cruiseName"] as? String ?? ""
            let visitingPlace = cruiseData["visitingPlace"] as? String ?? ""
            let price = cruiseData["price"] as? String ?? ""
            let duration = cruiseData["duration"] as? String ?? ""

            // Combine the cruise information into a single string
            let cruiseInfo = """
            Cruise Information:
            Cruise Name: \(cruiseName)
            Visiting Place: \(visitingPlace)
            Price: \(price)
            Duration: \(duration)
            """

            // Append the cruise information to the ReservationDetails label
            ReservationDetails.text?.append("\n\n\(cruiseInfo)")
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
            ReservationDetails.text?.append("\n\n\(guestInfo)")
        } else {
            print("Error converting guest data to integers")
        }
    }


}
