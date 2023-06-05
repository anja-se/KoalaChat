//
//  RegisterViewController.swift
//  KoalaChat
//
//  Created by Anja Seidel on 06.03.23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let username = usernameTextfield.text, let email = emailTextfield.text, let password = passwordTextField.text {
            Task{
                do {
                    try await authService.createAccount(name: username, email: email, password: password)
                    if authService.user != nil {
                        self.performSegue(withIdentifier: K.registerSegue, sender: self)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
