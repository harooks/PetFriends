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
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
