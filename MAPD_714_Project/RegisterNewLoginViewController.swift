//
//  RegisterNewLoginViewController.swift
//  MAPD_714_Project
//
//  Created by Jeet Panchal on 2023-12-03.
//

import UIKit

class RegisterNewLoginViewController: UIViewController {

    
    @IBOutlet weak var BackBtn: UIButton!
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var Address: UITextField!
    @IBOutlet weak var City: UITextField!
    @IBOutlet weak var Country: UITextField!
    @IBOutlet weak var PhoneNo: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToHomeButtonTapped(_ sender: UIButton) {
            performSegue(withIdentifier: "backToHomeSegue", sender: self)
        }
    
    @IBAction func registerNewButtonTapped(_ sender: UIButton) {
        if validateInput() {
            saveDataToNewUserTable()
        }
    }
    
    private func validateInput() -> Bool {
        // Check if at least one field is filled
        guard
            let name = UserName.text, !name.isEmpty,
            let address = Address.text, !address.isEmpty,
            let city = City.text, !city.isEmpty,
            let country = Country.text, !country.isEmpty,
            let phone = PhoneNo.text, !phone.isEmpty,
            let email = Email.text, !email.isEmpty,
            let password = Password.text, !password.isEmpty
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
    
    private func saveDataToNewUserTable() {
        let name = UserName.text ?? ""
        let address = Address.text ?? ""
        let city = City.text ?? ""
        let country = Country.text ?? ""
        let phone = PhoneNo.text ?? ""
        let email = Email.text ?? ""
        let password = Password.text ?? ""
        
        // Assuming DatabaseManager has a method insertIntoGuestLogin with appropriate parameters
        DatabaseManager.shared.insertIntoNewUserLogin(name: name, address: address, city: city, country: country, phone: phone, email: email, password: password)
        
        print("New User Login Saved Successful")
        
        // Display a success message
            showAlertSuccess(message: "New User Login Data has been saved successfully.")
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
