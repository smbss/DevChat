//
//  LoginVC.swift
//  DevChat
//
//  Created by smbss on 22/02/2017.
//  Copyright © 2017 smbss All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: RoundTextField!
    @IBOutlet weak var passwordField: RoundTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        print("CurrentUserUID: \(FIRAuth.auth()?.currentUser?.uid)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            guard FIRAuth.auth()?.currentUser == nil else {
                // Load Camera VC
            performSegue(withIdentifier: "LoginToCamera", sender: nil)
            return
        }
    }


    @IBAction func loginPressed(_ sender: AnyObject) {
        if let email = emailField.text, let pass = passwordField.text, (email.characters.count > 0 && pass.characters.count > 0) {
            print("AuthService.instance.login \(email) and \(pass)")
                // Call the login service
            AuthService.instance.login(email: email, password: pass, onComplete: { (errMsg, data) in
                guard errMsg == nil else {
                    self.showAlert(title: "Authentication Error", message: errMsg! , buttonText: "Ok")
                    return
                }
                //self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "LoginToCamera", sender: nil)
            })
        } else {
            showAlert(title: "Username and Password Required", message: "You must enter both a username and a password", buttonText: "Ok")
        }
    }
    
    func showAlert(title: String, message: String, buttonText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
}
