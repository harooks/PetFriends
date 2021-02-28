//
//  Design.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/27/21.
//

import Foundation
import UIKit

class Design: UIColor {

    let themeColor = UIColor(red: 160/255, green: 207/255, blue: 103/255, alpha: 1.0)
    
    var cornerRadius:(UIView) -> () = { view in
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
    }

//    func addLayerToShadow1() -> UIView{
//        let shadow = UIView()
//        let shadowLayer = CALayer()
//
//        let shadowPath = UIBezierPath(roundedRect: shadow.bounds, cornerRadius: 10)
//        shadowLayer.shadowPath = shadowPath.cgPath
//        shadowLayer.shadowColor = UIColor(red: 0.741, green: 0.957, blue: 0.478, alpha: 0.4).cgColor
//        shadowLayer.shadowOpacity = 1
//        shadowLayer.shadowRadius = 3
//        shadowLayer.shadowOffset = CGSize(width: -3, height: -3)
//        shadowLayer.bounds = shadow.bounds
//        shadowLayer.position = shadow.center
//        shadow.layer.addSublayer(shadowLayer) //returns void
//        //adds shadowloayer to shadow
//        return shadow
//    }
//
//    func dropShadow1(view: UIView) {
//        let layeredShadow = addLayerToShadow1()
//        layeredShadow.frame = view.frame
//        layeredShadow.clipsToBounds = false
//        view.addSubview(layeredShadow)
//    }
    

    
    
    
}
