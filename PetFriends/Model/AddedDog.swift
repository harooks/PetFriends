//
//  AddedDog.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/25/21.
//
import Foundation
import FirebaseFirestore


struct AddedDogStruct {
//    var id: String
    var name: String
    var breed: String
    var gender: Bool
    var fav: Bool
    var bio: String
//    var imageUrl: String
}

struct MyDogStruct {
    var name: String
    var breed: String
    var gender: Bool
    var bio: String
}


class AddedDog//: NSObject
{

//    var name: String
//    var breed: String
//    var gender: Bool
//    var bio: String
//    var imageUrl: String
//
//
//    init(document: QueryDocumentSnapshot) {
//       let Dic = document.data()
//       self.name = Dic["name"] as? String ?? ""
//       self.breed = Dic["breed"] as? String ?? ""
//       self.gender = Dic["gender"] as? Bool ?? true
//       self.bio = Dic["bio"] as? String ?? ""
//       self.imageUrl = Dic["imageUrl"] as? String ?? ""
//   }
}


