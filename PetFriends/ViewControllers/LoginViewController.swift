//
//  LoginViewController.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/24/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func validateTextFields() -> String? {
        //check all textfields are filled in
        if emailTextField.text == "" || passwordTextField.text == "" {
            return "空白があります。"
        }
        return nil
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        let error = validateTextFields()
              
              if error != nil {
                  //エラ〜メッセージを表示
                  errorLabel.text = error!
              } else {
              //create cleaned version of data
              let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
              let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
              //Signin the user
                  Auth.auth().signIn(withEmail: email, password: password) {(result, error) in
                      
                      if error != nil {
                          //couldn't login
                          self.showError(_message: "docchika chigau")
                      } else {
                          
                      //go to home screen
                      self.transitionToHome()
                      }
                  }

              }
    }
    
    func showError(_message:String) {
        errorLabel.text = _message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
            
        let homevc = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
        view.window?.rootViewController = homevc
        view.window?.makeKeyAndVisible()
    }

}
