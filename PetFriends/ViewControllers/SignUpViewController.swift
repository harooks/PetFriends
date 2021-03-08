//
//  SignUpViewController.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/24/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var design = Design()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = design.themeColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = design.subColor
        
//        firstNameTextField.borderStyle = .roundedRect
        firstNameTextField.layer.cornerRadius = 10
        firstNameTextField.layer.borderWidth = 1.5
        firstNameTextField.layer.borderColor = design.subColor.cgColor
        firstNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: firstNameTextField.frame.height))
        firstNameTextField.leftViewMode = .always
        
//        lastNameTextField.borderStyle = .roundedRect
        lastNameTextField.layer.cornerRadius = 10
        lastNameTextField.layer.borderWidth = 1.5
        lastNameTextField.layer.borderColor = design.subColor.cgColor
        lastNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: lastNameTextField.frame.height))
        lastNameTextField.leftViewMode = .always
        
//        emailTextField.borderStyle = .roundedRect
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderWidth = 1.5
        emailTextField.layer.borderColor = design.subColor.cgColor
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: emailTextField.frame.height))
        emailTextField.leftViewMode = .always
                
//        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderWidth = 1.5
        passwordTextField.layer.borderColor = design.subColor.cgColor
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: passwordTextField.frame.height))
        passwordTextField.leftViewMode = .always
    
        signupButton.layer.cornerRadius = 10
    }
    
    func validateFields() -> String? {
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "全て記入してください"
        } else {
        return nil
        }
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        let errorMessage = validateFields()
        
        if errorMessage != nil {
            showError(_message: errorMessage!)
        }
        else {
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    
                    self.showError(_message: "error creating user")
                } else {
                    let db = Firestore.firestore()
                    //  db.collection("users").document(result!.user.uid).setData(["email": email, "password": password, "didGiveBreakfast": false, "didGiveDinner": false, "uid": result!.user.uid])
                    
                    db.collection("users").document(result!.user.uid).setData(["firstName":firstName, "lastName":lastName, "uid":result!.user.uid])  { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                            self.transitionToHome()
                        }
                    }
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
