//
//  AddedDog.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/25/21.
//
import Foundation
import Firebase

struct AddedDogStruct {
    var name: String
//    var image: String
    var breed: String
    var gender: Bool
    var bio: String
}

class AddedDog: NSObject {
//    var uid: String?
    var name: String
//    var image: String
    var breed: String
    var gender: Bool
    var bio: String
    

    init(document: QueryDocumentSnapshot) {
       let Dic = document.data()
        self.name = Dic["name"] as? String ?? ""
       self.breed = Dic["breed"] as? String ?? ""
        self.gender = Dic["gender"] as? Bool ?? true
       self.bio = Dic["String"] as? String ?? ""
   }
}


