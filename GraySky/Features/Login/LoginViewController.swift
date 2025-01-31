//
//  LoginViewController.swift
//  GraySky
//
//  Created by Umut Konmuş on 31.12.2024.
//

import UIKit

class LoginViewController: UIViewController, LoginViewModelDelegate {
    

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        passwordText.isSecureTextEntry = true
    }
    
    @IBAction func singInClicked(_ sender: Any) {
        if let email = emailText.text {
            if let password = passwordText.text {
                viewModel.singInOrCreateUser(email: email,password: password)
            }
        }
    }
    
    func logged() {
        performSegue(withIdentifier: "toMainApp", sender: nil)
    }
    
    
    
}
