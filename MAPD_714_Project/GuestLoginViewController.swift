//  GuestLoginViewController.swift
//  MAPD_714_Project
//
//  Created by Jeet Panchal on 2023-12-03.
//

import UIKit

class GuestLoginViewController: UIViewController {

    @IBOutlet weak var BackBtn: UIButton!
    @IBOutlet weak var RegisterNewBtn: UIButton!
    @IBOutlet weak var GuestName: UITextField!
    @IBOutlet weak var GuestAddress: UITextField!
    @IBOutlet weak var GuestCity: UITextField!
    @IBOutlet weak var GuestCountry: UITextField!
    @IBOutlet weak var GuestPhNo: UITextField!
    @IBOutlet weak var GuestEmail: UITextField!
    @IBOutlet weak var GuestPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToHomeButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "backToHomeSegue", sender: self)
    }
    
    @IBAction func registerNewButtonTapped(_ sender: UIButton) {
        if validateInput() {
            saveDataToGuestTable()
        }
    }
    
    private func validateInput() -> Bool {
        // Check if at least one field is filled
        guard
            let name = GuestName.text, !name.isEmpty,
            let address = GuestAddress.text, !address.isEmpty,
            let city = GuestCity.text, !city.isEmpty,
            let country = GuestCountry.text, !country.isEmpty,
            let phone = GuestPhNo.text, !phone.isEmpty,
            let email = GuestEmail.text, !email.isEmpty,
            let password = GuestPassword.text, !password.isEmpty
        else {
            showAlert(message: "Please fill in all fields.")
            return false
        }

        // Validate guest name
        let nameCharacterSet = CharacterSet.letters
        guard let _ = name.rangeOfCharacter(from: nameCharacterSet) else {
            showAlert(message: "Guest name should only contain letters.")
            print("Guest name should only contain letters.")
            return false
        }

        // Validate guest phone number format
        let phoneRegex = "^\\d{10}$"
        guard NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone) else {
            showAlert(message: "Please enter a valid 10-digit phone number.")
            print("Please enter a valid 10-digit phone number.")
            return false
        }

        // Validate guest email format
        guard isValidEmail(email) else {
            showAlert(message: "Please enter a valid email address.")
            print("Please enter a valid email address.")
            return false
        }

        // Validate guest password
        guard isStrongPassword(password) else {
            showAlert(message: "Password must be at least 8 characters long and contain a combination of letters and numbers.")
            print("Password must be at least 8 characters long and contain a combination of letters and numbers.")
            return false
        }

        // Validate guest country
        guard !country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(message: "Please enter guest country.")
            print("Please enter guest country.")
            return false
        }

        // Validate guest city
        guard !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(message: "Please enter guest city.")
            print("Please enter guest city.")
            return false
        }

        // Validate guest address
        guard !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(message: "Please enter guest address.")
            print("Please enter guest address.")
            return false
        }

        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func isStrongPassword(_ password: String) -> Bool {
        // Password must be at least 8 characters long and contain a combination of letters and numbers
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    private func saveDataToGuestTable() {
        let name = GuestName.text ?? ""
        let address = GuestAddress.text ?? ""
        let city = GuestCity.text ?? ""
        let country = GuestCountry.text ?? ""
        let phone = GuestPhNo.text ?? ""
        let email = GuestEmail.text ?? ""
        let password = GuestPassword.text ?? ""
        
        // Assuming DatabaseManager has a method insertIntoGuestLogin with appropriate parameters
        DatabaseManager.shared.insertIntoGuestLogin(name: name, address: address, city: city, country: country, phone: phone, email: email, password: password)
        
        print("Guest Login Saved Successful")
        
        // Display a success message
            showAlertSuccess(message: "Guest Login Data has been saved successfully.")
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
    
    
    @IBAction func ProfileDetailsBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "ProfileDetailsegue", sender: self)
    }
    
}
