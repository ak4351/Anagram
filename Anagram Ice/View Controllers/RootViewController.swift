//
//  RootViewController.swift
//  Anagram Ice
//
//  Created by Anthony_Kasper on 6/10/20.
//  Copyright © 2020 FirstTry. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "logInSegue", sender: self)
    }
}
