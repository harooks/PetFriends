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
    
    var design = Design()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = design.themeColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = design.subColor
        
//        emailTextField.borderStyle = .none
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderWidth = 1.5
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.borderColor = design.subColor.cgColor
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: emailTextField.frame.height))
        emailTextField.leftViewMode = .always
                
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderWidth = 1.5
        passwordTextField.layer.borderColor = design.subColor.cgColor
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: passwordTextField.frame.height))
        passwordTextField.leftViewMode = .always
        
        loginButton.layer.cornerRadius = 10
        
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
                          self.showError(_message: "メールかパスワードが違います")
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
