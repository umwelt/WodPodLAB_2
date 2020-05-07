//
//  AuthViewController.swift
//  WodPodLab
//
//  Created by Hugo Perez on 22/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import UIKit
import SDCAlertView
import Firebase
import PromiseKit

class AuthViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Access"
        
        if Auth.auth().currentUser?.uid != nil {
            self.accessMenu()
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonWasPressed(_ sender: Any) {
        self.validateCredentials()
    }
    
    
    fileprivate func validateCredentials() {
        
        guard let _username = usernameTextField.text else {
            AlertController.alert(withTitle: "Error", message: "email cant be empty", actionTitle: "OK")
            return
        }
        
        guard let _password = passwordTextField.text else {
            AlertController.alert(withTitle: "Error", message: "email cant be empty", actionTitle: "OK")
            return
        }
        
        firstly {
            FireSession.shared.userLogin(username: _username, password: _password)
        }.catch { (error) in
            AlertController.alert(withTitle: "Error", message: error.localizedDescription, actionTitle: "OK")
        }.finally {
            self.accessMenu()
        }
        
    }
    
    
    fileprivate func accessMenu() {
        let menuController = MenuViewController()
        self.navigationController?.pushViewController(menuController, animated: true)
    }
    


}
