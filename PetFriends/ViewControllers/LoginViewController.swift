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
    let dogFirebase = DogFirebase()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = design.themeColor
        navigationController?.navigationBar.shadowImage = UIImage()
 //       navigationController?.navigationBar.tintColor = design.subColor
        

        design.textFieldDesign(textField: emailTextField)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        design.textFieldDesign(textField: passwordTextField)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])

        
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
                dogFirebase.login(email: email, password: password)

                          
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                      self.transitionToHome()
                        }
                        
                      }
    }
    
    func showError(_message:String) {
        errorLabel.text = _message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
            
        let homevc = storyboard?.instantiateViewController(identifier: "TabVC") as? UITabBarController
        view.window?.rootViewController = homevc
        view.window?.makeKeyAndVisible()
    }

}
