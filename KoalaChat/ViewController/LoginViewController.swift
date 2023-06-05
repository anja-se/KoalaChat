//
//  LoginViewController.swift
//  KoalaChat
//
//  Created by Anja Seidel on 06.03.23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    private let authService = AppDelegate.authService
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            authService.signIn(email: email, password: password) {
                self.performSegue(withIdentifier: K.loginSegue, sender: self)
            }
        }
    }
}
