//
//  CubaViewController.swift
//  MAPD_714_Project
//
//  Created by Jeet Panchal on 2023-12-03.
//

import UIKit

class CubaViewController: UIViewController {

    @IBOutlet weak var CruiseHeading: UILabel!
    @IBOutlet weak var VisitingPlace: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var Duration: UILabel!
    
    // Declare DatabaseManager instance
        let databaseManager = DatabaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func BookCruiseBtnTapped(_ sender: Any) {
        
        // Accessing text from the labels
        let cruiseHeadingText = CruiseHeading.text ?? ""
        let visitingPlaceText = VisitingPlace.text?.replacingOccurrences(of: "'", with: "''") ?? ""
        let priceText = Price.text ?? ""
        let durationText = Duration.text ?? ""
        
        // Now you can use these text values as needed
        print("Cruise Name: \(cruiseHeadingText)")
        print("Visiting Place: \(visitingPlaceText)")
        print("Price: \(priceText)")
        print("Duration: \(durationText)")
        
        // Save data in the CruiseSelected table
        databaseManager.insertIntoCruiseSelected(cruiseName: cruiseHeadingText, visitingPlace: visitingPlaceText, price: priceText, duration: durationText)
        
        // Display data saved in the database
        if let mostRecentCruiseData = databaseManager.getMostRecentCruiseSelectedData() {
            print("\nData saved in CruiseSelected table:")
            for (key, value) in mostRecentCruiseData {
                print("\(key): \(value)")
            }
            // Perform segue to GuestInformationViewController
                    performSegue(withIdentifier: "GuestInfoSegue", sender: self)
        } else {
            print("\nError retrieving data from CruiseSelected table")
        }
    }
}
