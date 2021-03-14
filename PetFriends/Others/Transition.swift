//
//  Transition.swift
//  PetFriends
//
//  Created by Haruko Okada on 3/13/21.
//

import Foundation
import UIKit

class Transition {
    
    func transitionToHome(vc: UIViewController) {
            
        let destvc = vc.storyboard?.instantiateViewController(identifier: "TabVC")
        vc.view.window?.rootViewController = destvc
        vc.view.window?.makeKeyAndVisible()
    
    }
      
}
