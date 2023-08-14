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
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var registerButton: UIButton!
    
    private let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        activityIndicator.isHidden = true
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let username = usernameTextfield.text, let email = emailTextfield.text, let password = passwordTextField.text {
            startLoading()
            authService.createAccount(name: username, email: email, password: password) { success, error in
                DispatchQueue.main.async {
                    if success {
                        
                            self.performSegue(withIdentifier: K.registerSegue, sender: self)
                            self.stopLoading()
                            self.infoLabel.isHidden = true
                        
                    } else {
                        self.infoLabel.isHidden = false
                        self.infoLabel.text = error?.localizedDescription
                        self.stopLoading()
                    }
                }
            }
        }
    }
    
    func startLoading() {
        registerButton.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        registerButton.isHidden = false
    }
}
