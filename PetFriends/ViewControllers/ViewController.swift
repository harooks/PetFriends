//
//  ViewController.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/23/21.
//

import UIKit

class ViewController: UIViewController {
      
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createNewAccountButton: UIButton!
    var design = Design()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
 //       self.navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.barTintColor = design.themeColor
        navigationController?.navigationBar.shadowImage = UIImage()
        loginButton.layer.cornerRadius = 10
        createNewAccountButton.layer.cornerRadius = 10
    }
}




