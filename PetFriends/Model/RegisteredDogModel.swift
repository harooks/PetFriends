//
//  RegisteredDogModel.swift
//  PetFriends
//
//  Created by Haruko Okada on 3/8/21.
//

import Foundation

class RegisteredDogModel {
    
    let id: String
    let name: String
    let breed: String
    let gender: Bool
    let bio: String
    let imageUrl: String
    
    init(dic: [String: Any]) {
       self.id = dic["id"] as? String ?? ""
       self.name = dic["name"] as? String ?? ""
       self.breed = dic["breed"] as? String ?? ""
       self.gender = dic["gender"] as? Bool ?? true
       self.bio = dic["bio"] as? String ?? ""
       self.imageUrl = dic["imageUrl"] as? String ?? ""
   }
}
