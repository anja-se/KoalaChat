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
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let authService = AppDelegate.authService
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            startLoading()
            authService.signIn(email: email, password: password) { success, error in
                if success {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
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
    
    func startLoading() {
        loginButton.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        loginButton.isHidden = false
    }
}
