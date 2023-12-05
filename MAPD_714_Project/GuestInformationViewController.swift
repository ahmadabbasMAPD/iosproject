//
//  GuestInformationViewController.swift
//  MAPD_714_Project
//
//  Created by Jeet Panchal on 2023-12-03.
//

import UIKit

class GuestInformationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Outlets

    @IBOutlet weak var NumberOfAdult: UIPickerView!
    @IBOutlet weak var NumberOfKids: UIPickerView!
    @IBOutlet weak var SeniorSwitch: UISwitch!
    @IBOutlet weak var NumberOfSenior: UIPickerView!
    @IBOutlet weak var GoToPaymentScreen: UIButton!

    // MARK: - Properties

    var name: String?
    var place: String?
    var price: String?
    var startDate: String?
    var numberOfNights: String?
    let numberOfPeopleRange = Array(0...10)

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set delegates and data sources for picker views
        NumberOfAdult.delegate = self
        NumberOfAdult.dataSource = self
        NumberOfKids.delegate = self
        NumberOfKids.dataSource = self
        NumberOfSenior.delegate = self
        NumberOfSenior.dataSource = self

        // Do any additional setup after loading the view.

    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfPeopleRange.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberOfPeopleRange[row])"
    }

    // MARK: - Actions

    @IBAction func GoToPaymentScreen(_ sender: Any) {
        // Check for validation before proceeding to PaymentViewController
        if validateData() {
            // Check for seniors and show confirmation popup
            if SeniorSwitch.isOn && NumberOfSenior.selectedRow(inComponent: 0) > 0 {
                showSeniorConfirmationPopup()
            } else {
                // Show confirmation popup without checking seniors
                showConfirmationPopup(message: "Confirmation", detail: "Are you sure you want to proceed?")
                // Save guest information data
                        saveGuestInformationData()
            }
        }
    }

    // MARK: - Confirmation Popup for Seniors

    func showSeniorConfirmationPopup() {
        let message = "Are you sure you want to proceed with senior travelers over 60?"
        showConfirmationPopup(message: "Senior Confirmation", detail: message, isSeniorConfirmation: true)
    }

    // Handle user response to senior confirmation
    func handleSeniorConfirmationResponse(confirmed: Bool) {
        let numberOfSeniors = NumberOfSenior.selectedRow(inComponent: 0)
        
        if confirmed {
            if numberOfSeniors > 0 {
                showSecondConfirmationPopup(message: "Senior Confirmation", detail: "Proceeding with senior travelers over 60.")
                // Save guest information data
                        saveGuestInformationData()
            } else {
                showSecondConfirmationPopup(message: "Confirmation", detail: "Proceeding without senior travelers.")
                // Save guest information data
                        saveGuestInformationData()
            }
        } else {
            showErrorPopup(message: "Senior Confirmation", detail: "You chose not to proceed with senior travelers over 60.")
            // Save guest information data
                    saveGuestInformationData()
        }
    }

    // Second Confirmation Popup
    func showSecondConfirmationPopup(message: String, detail: String) {
        let alertController = UIAlertController(title: message, message: detail, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "PaymentSegueIdentifier", sender: self)
            
        }))

        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Validation

    func validateData() -> Bool {
        let numberOfAdults = NumberOfAdult.selectedRow(inComponent: 0)
        let numberOfKids = NumberOfKids.selectedRow(inComponent: 0)
        let isSeniorSelected = SeniorSwitch.isOn
        let numberOfSeniors = NumberOfSenior.selectedRow(inComponent: 0)

        // Check for empty fields
        guard numberOfAdults > 0 || numberOfKids > 0 || isSeniorSelected || numberOfSeniors > 0 else {
            showErrorPopup(message: "Validation Error", detail: "Please select the number of adults, kids, or seniors.")
            return false
        }

        // Validate data based on your requirements
        if numberOfAdults == 0 && numberOfKids > 0 {
            print("Validation Error: Without adults, you cannot reserve a booking for kids.")
            showErrorPopup(message: "Reservation Error", detail: "Without adults, you cannot reserve a booking for kids.")
            return false
        }

        if isSeniorSelected && numberOfSeniors == 0 {
            showErrorPopup(message: "Validation Error", detail: "Please enter the number of senior travelers.")
            return false
        }

        if !isSeniorSelected && numberOfSeniors > 0 {
            showErrorPopup(message: "Validation Error", detail: "You selected 'No' in Senior Switch but entered the number of seniors.")
            return false
        }

        return true
    }

    // MARK: - Popups

    func showErrorPopup(message: String, detail: String) {
        let alertController = UIAlertController(title: message, message: detail, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func showConfirmationPopup(message: String, detail: String, isSeniorConfirmation: Bool = false) {
        let alertController = UIAlertController(
            title: NSLocalizedString(message, comment: ""),
            message: NSLocalizedString(detail, comment: ""),
            preferredStyle: .alert
            
        )

        alertController.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { _ in
            if isSeniorConfirmation {
                self.handleSeniorConfirmationResponse(confirmed: true)
            } else {
                self.performSegue(withIdentifier: "PaymentSegueIdentifier", sender: self)
                
            }
        }))

        alertController.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))

        present(alertController, animated: true, completion: nil)
    }

    func saveGuestInformationData() {
        let numberOfAdults = NumberOfAdult.selectedRow(inComponent: 0)
        let numberOfKids = NumberOfKids.selectedRow(inComponent: 0)
        let numberOfSeniors = NumberOfSenior.selectedRow(inComponent: 0)
        
        // Use your DatabaseManager.shared instance to insert data into GuestInformationSelected table
        DatabaseManager.shared.insertIntoGuestInformationSelected(adults: numberOfAdults, kids: numberOfKids, seniors: numberOfSeniors)
        
        print("Guest information data saved successfully.")
        
        // Print the saved data
            if let recentData = DatabaseManager.shared.getMostRecentGuestInformationSelectedData() {
                print("Saved Guest Information Data:")
                for (key, value) in recentData {
                    print("\(key): \(value)")
                }
            } else {
                print("Error retrieving saved Guest Information data.")
            }
    }
    
    
}
