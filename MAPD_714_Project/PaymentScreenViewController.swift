//
//  PaymentScreenViewController.swift
//  MAPD_714_Project
//
//  Created by Jeet Panchal on 2023-12-03.
//

import UIKit

class PaymentScreenViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var PaymentType: UIPickerView!
    @IBOutlet weak var CardNumber: UITextField!
    @IBOutlet weak var CardHolderName: UITextField!
    @IBOutlet weak var ExpiryDate: UITextField!

    let paymentOptions = ["Select Card", "Credit Card", "Debit Card"]
    var selectedPaymentType: String?

    // Enum for error types
    enum ValidationError: String {
        case generic = "Error"
        case cardNumber = "Card Number Error"
        case cardHolderName = "Cardholder Name Error"
        case expiryDate = "Expiry Date Error"

        var title: String {
            return rawValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        PaymentType.delegate = self
        PaymentType.dataSource = self
    }

    // MARK: UIPickerViewDelegate and UIPickerViewDataSource methods

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return paymentOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return paymentOptions[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPaymentType = paymentOptions[row]
    }

    // MARK: Expiry Date Validation

    func isValidExpiryDate(_ expiryDate: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let inputDate = dateFormatter.date(from: expiryDate) else {
            return false
        }

        let currentDate = Date()
        return inputDate > currentDate
    }

    // Function to show error popup with enum for error types
    func showErrorPopup(message: String, errorType: ValidationError = .generic) {
        let alert = UIAlertController(title: errorType.title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        okAction.accessibilityIdentifier = "OKButton" // Optional: For UI testing
        present(alert, animated: true, completion: nil)
    }

    @IBAction func NextBtnTapped(_ sender: Any) {
        let cardNumberLimit = 16 // Adjust the limit based on your requirements

        guard let paymentType = selectedPaymentType, paymentType != "Select Card" else {
            showErrorPopup(message: "Please select a valid payment type.")
            return
        }

        guard let cardNumber = CardNumber.text?.trimmingCharacters(in: .whitespaces), !cardNumber.isEmpty, cardNumber.isNumeric else {
            showErrorPopup(message: "Please enter a valid 16-digit card number.", errorType: .cardNumber)
            return
        }

        guard cardNumber.count == cardNumberLimit else {
            showErrorPopup(message: "Card number should be \(cardNumberLimit) digits.", errorType: .cardNumber)
            return
        }

        guard let cardHolderName = CardHolderName.text, !cardHolderName.isEmpty, cardHolderName.isAlpha else {
            showErrorPopup(message: "Please enter a valid cardholder name.", errorType: .cardHolderName)
            return
        }

        // Adjust the format based on your actual date format
        guard let expiryDate = ExpiryDate.text?.trimmingCharacters(in: .whitespaces), !expiryDate.isEmpty, isValidExpiryDate(expiryDate) else {
            showErrorPopup(message: "Please enter a valid expiry date (e.g., 12/23).", errorType: .expiryDate)
            return
        }

        // Validation successful, perform segue
        performSegue(withIdentifier: "showReservationInformation", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReservationInformation" {
            // Pass data to the next view controller if needed
            if let destinationVC = segue.destination as? ReservationInformationViewController {
                destinationVC.paymentType = selectedPaymentType
                destinationVC.cardNumber = CardNumber.text
                destinationVC.cardHolderName = CardHolderName.text
                destinationVC.expiryDate = ExpiryDate.text
            }
        }
    }
}

// Extension to check if a String contains only numeric characters
extension String {
    var isNumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }

    // Extension to check if a String contains only alphabetical characters
    var isAlpha: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
}
