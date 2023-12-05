//
//  UpdateProfileViewController.swift
//  MAPD_714_Project
//
//  Created by Jeet Panchal on 2023-12-03.
//

import UIKit

class UpdateProfileViewController: UIViewController {

    @IBOutlet weak var UpdateName: UITextField!
    @IBOutlet weak var UpdateAddress: UITextField!
    @IBOutlet weak var UpdateCity: UITextField!
    @IBOutlet weak var UpdateCountry: UITextField!
    @IBOutlet weak var UpdatePhoneNo: UITextField!
    @IBOutlet weak var UpdateEmail: UITextField!
    @IBOutlet weak var UpdatePassword: UITextField!
    
    let databaseManager = DatabaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Display the most recent user or guest data in the text fields
        if let mostRecentData = databaseManager.getMostRecentUserData(tableName: "NewUserLogin") ?? databaseManager.getMostRecentUserData(tableName: "GuestLogin") {
            UpdateName.text = mostRecentData["name"] as? String
            UpdateAddress.text = mostRecentData["address"] as? String
            UpdateCity.text = mostRecentData["city"] as? String
            UpdateCountry.text = mostRecentData["country"] as? String
            UpdatePhoneNo.text = mostRecentData["phone"] as? String
            UpdateEmail.text = mostRecentData["email"] as? String
            UpdatePassword.text = mostRecentData["password"] as? String
        }
    }
    
    @IBAction func UpdateDataBtnTapped(_ sender: Any) {
        // Collect updated data from text fields
        guard let name = UpdateName.text,
              let address = UpdateAddress.text,
              let city = UpdateCity.text,
              let country = UpdateCountry.text,
              let phone = UpdatePhoneNo.text,
              let email = UpdateEmail.text,
              let password = UpdatePassword.text else {
            // Display an alert if any field is empty
            showAlert(message: "Please fill in all fields.")
            return
        }
        
        // Perform validations
        if validateInput(name: name, phone: phone, email: email, password: password, country: country, city: city, address: address) {
            // Update the most recent user or guest data
            if let mostRecentData = databaseManager.getMostRecentUserData(tableName: "NewUserLogin") {
                // Update data for the NewUserLogin table
                databaseManager.updateMostRecentUserData(tableName: "NewUserLogin", newData: [
                    "name": name,
                    "address": address,
                    "city": city,
                    "country": country,
                    "phone": phone,
                    "email": email,
                    "password": password
                ])
            } else if let mostRecentData = databaseManager.getMostRecentUserData(tableName: "GuestLogin") {
                // Update data for the GuestLogin table
                databaseManager.updateMostRecentUserData(tableName: "GuestLogin", newData: [
                    "name": name,
                    "address": address,
                    "city": city,
                    "country": country,
                    "phone": phone,
                    "email": email,
                    "password": password
                ])
            }
            
            // Display a success message
            showAlertSuccess(message: "Profile Updated Successfully.")
        }
    }
    
    private func validateInput(name: String, phone: String, email: String, password: String, country: String, city: String, address: String) -> Bool {
        // Check if at least one field is filled
        guard
            !name.isEmpty,
            !address.isEmpty,
            !city.isEmpty,
            !country.isEmpty,
            !phone.isEmpty,
            !email.isEmpty,
            !password.isEmpty
        else {
            showAlert(message: "Please fill in all fields.")
            return false
        }

        // Validate name
        let nameCharacterSet = CharacterSet.letters
        guard let _ = name.rangeOfCharacter(from: nameCharacterSet) else {
            showAlert(message: "Name should only contain letters.")
            return false
        }

        // Validate phone number format
        let phoneRegex = "^\\d{10}$"
        guard NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone) else {
            showAlert(message: "Please enter a valid 10-digit phone number.")
            return false
        }

        // Validate email format
        guard isValidEmail(email) else {
            showAlert(message: "Please enter a valid email address.")
            return false
        }

        // Validate password
        guard isStrongPassword(password) else {
            showAlert(message: "Password must be at least 8 characters long and contain a combination of letters and numbers.")
            return false
        }

        // Validate country
        guard !country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(message: "Please enter a country.")
            return false
        }

        // Validate city
        guard !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(message: "Please enter a city.")
            return false
        }

        // Validate address
        guard !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(message: "Please enter an address.")
            return false
        }

        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func isStrongPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    private func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showAlertSuccess(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
