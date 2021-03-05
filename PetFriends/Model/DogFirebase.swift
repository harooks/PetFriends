//
//  dogFirebase.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/25/21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class DogFirebase {
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    var uidString = String()
 
    init() {
        self.uidString = String(currentUser!.uid)
    }
   

    func getDogData(dog: AddedDogStruct?, imageUrl: String) {
        
        let ref = db.collection("users").document(uidString).collection("savedDogs")
        let id = ref.document().documentID

        let someData = [
            "id": id,
            "name": dog?.name,
            "breed": dog?.breed,
            "gender": dog?.gender,
            "bio": dog?.bio,
            "imageUrl": imageUrl,
        ] as [String : Any]
        
        ref.document(id).setData(someData, merge: true)
    }
    
    
    func uploadImage(addedDog: AddedDogStruct, view: UIImageView) {

        guard let imageData = view.image?.jpegData(compressionQuality: 0.75) else {
            print("not working")
            return }
        
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "dog/\(randomID).jpeg")

        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"

        uploadRef.putData(imageData, metadata: uploadMetadata) {(downloadMetaData, err) in
            if let err = err {
                print("there is an error: \(err)")
            } else {
                print("put is complete \(downloadMetaData)")
            }
            
            uploadRef.downloadURL { (url, err) in
                if let err = err {
                    print("error downloading url \(err)")
                    return
                }
                
                guard let urlString = url?.absoluteString else {return}
                self.getDogData(dog: addedDog , imageUrl: urlString)
            }
        }
    }
    

    func updateData(id: String, name: String, breed: String, bio: String, gender: Bool, imageUrl: String) {
        
        let ref = db.collection("users").document(uidString).collection("savedDogs")
        
        let someData = [
            "id": id, //まだ保存前だから nil になってしまう
            "name": name,
            "breed": breed,
            "gender": gender,
            "bio": bio,
            "imageUrl": imageUrl,
        ] as [String : Any]
        
        ref.document(id).updateData(someData)
        
    }
    
    func updateImage(id: String, name: String, breed: String, bio: String, gender: Bool, view: UIImageView) {
        guard let imageData = view.image?.jpegData(compressionQuality: 0.75) else {
            print("not working")
            return }
        
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "dog/\(randomID).jpeg")

        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"

        uploadRef.putData(imageData, metadata: uploadMetadata) {(downloadMetaData, err) in
            if let err = err {
                print("there is an error: \(err)")
            } else {
                print("put is complete \(downloadMetaData)")
            }
            
            uploadRef.downloadURL { (url, err) in
                if let err = err {
                    print("error downloading url \(err)")
                    return
                }
                
                guard let urlString = url?.absoluteString else {return}
                let ref = self.db.collection("users").document(self.uidString).collection("savedDogs")
                
                let someData = [
                    "id": id, //まだ保存前だから nil になってしまう
                    "name": name,
                    "breed": breed,
                    "gender": gender,
                    "bio": bio,
                    "imageUrl": urlString
                ] as [String : Any]
                
                ref.document(id).updateData(someData)
            }
        }

    }

    
    
    
    func getSavedDogData (completion: @escaping ([DogModel]) -> ()) {
        var savedDogArray = [DogModel]()
        db.collection("users").document(uidString).collection("savedDogs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let dic = document.data()
                    let dog = DogModel.init(dic: dic)
                    savedDogArray.append(dog)
                    print("data name is: \(dog.name)")
                    completion(savedDogArray)
                }
            }
        }
    }
    
    

    
    
}
