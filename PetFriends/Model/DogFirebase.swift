//
//  dogFirebase.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/25/21.
//

import Foundation
import Firebase



let db = Firestore.firestore()
let currentUser = Auth.auth().currentUser
let uidString = String(currentUser!.uid)
class DogFirebase {
 
//var savedDogArray:[AddedDog] = []
  
// func getSavedDogData() -> [AddedDog] {
//    db.collection("users").document(uidString).collection("savedDogs").getDocuments() { (querySnapshot, err) in
//        if let err = err {
//            print("Error getting documents: \(err)")
//        } else {
//
//            for document in querySnapshot!.documents {
//
//                let data = AddedDog(document: document)
//                self.savedDogArray.append(data)
//                print(data.name)
// //               print(self.savedDogArray)
//            }
//        }
//    }
//      return savedDogArray
//    }
    
    func getSavedDogData (completion: @escaping ([AddedDog]) -> ()) {
        db.collection("users").document(uidString).collection("savedDogs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var savedDogArray = [AddedDog]()
                for document in querySnapshot!.documents {
                    let data = AddedDog(document: document)
                    savedDogArray.append(data)
//                    print(data.name)
                }
                completion(savedDogArray)
            }
  
        }
    }
    
    
}
