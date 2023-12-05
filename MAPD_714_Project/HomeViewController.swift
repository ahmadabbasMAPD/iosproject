//
//  ViewController.swift
//  MAPD_714_Project
//
//  Created by Jeet Panchal on 2023-12-02.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var LoginAsGuestBtn: UIButton!
    @IBOutlet weak var CreateNewAccountBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginAsGuestButtonTapped(_ sender: UIButton) {
        if let navigationController = self.navigationController {
            navigationController .performSegue(withIdentifier: "guestLoginSegue", sender: self)
        }
    }

    @IBAction func createNewAccountButtonTapped(_ sender: UIButton) {
        if let navigationController = self.navigationController {
            navigationController.performSegue(withIdentifier: "registerSegue", sender: self)
        }
    }


}

