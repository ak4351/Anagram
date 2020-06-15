//
//  SignUpViewController.swift
//  Anagram Ice
//
//  Created by Anthony_Kasper on 6/10/20.
//  Copyright © 2020 FirstTry. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTick: UILabel!
    @IBOutlet weak var passwordTick: UILabel!
    @IBOutlet weak var usernameTick: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eraseErrorLabels()
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        // 1. Check the Fields
        let isSafe:Bool = checkFields()
        if isSafe == false { return }
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let username = usernameTextField.text!
        
        
        // 2. Create User
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            // Check for errors with Firebase creating user
            if error != nil {
                // Error encountered
                self.errorLabel.text = "Error Creating User"
            }
            else {
                let db = Firestore.firestore()
                db.collection("Users").document(email).setData([
                     "email": email,
                     "password": password,
                     "username": username,
                     "uid": result!.user.uid,
                     "friendsList": []
                ]) { (error) in
                    
                    if error == nil {
                        // User was successfully created, and can be brought to the main screen
                        Account.displayName = username
                        self.performSegue(withIdentifier: "SignUp_to_HomeScreen", sender: self)
                    }
                    
                    if error != nil {
                        print("User was not added to database")
                        print(error.debugDescription)
                    }
                }
            }
        }
    }
    

    func checkFields() -> Bool {
        eraseErrorLabels()
        var hadBlanks = false
        
        // 1. Check Blank
        if emailTextField.text == "" {
            errorLabel.text = "Fields cannot be left blank"
            errorLabel.alpha = 1
            emailTick.alpha = 1
            hadBlanks = true
        }
        
        if passwordTextField.text == "" {
            errorLabel.text = "Fields cannot be left blank"
            errorLabel.alpha = 1
            passwordTick.alpha = 1
            hadBlanks = true
        }

        if usernameTextField.text == "" {
            errorLabel.text = "Fields cannot be left blank"
            errorLabel.alpha = 1
            usernameTick.alpha = 1
            hadBlanks = true
        }
        if hadBlanks == true {return false}
        
        // 2. Check Length
        if passwordTextField.text!.count < 8 {
            errorLabel.text = "Password must be at least 8 characters long"
            errorLabel.alpha = 1
            passwordTick.alpha = 1
        }
        
        return true
    }
    
    func eraseErrorLabels() {
        emailTick.alpha = 0
        passwordTick.alpha = 0
        usernameTick.alpha = 0
        errorLabel.alpha = 0
    }

    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
