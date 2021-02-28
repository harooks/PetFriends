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




class DogFirebase {
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    var uidString = String()
 
    init() {
        self.uidString = String(currentUser!.uid)
    }
    

    
    //ここで新しいドキュメント作成
    func getDogData(dog: AddedDogStruct?, imageUrl: String) {
        
        db.collection("users").document(uidString).collection("savedDogs").addDocument(data: [
            "name": dog?.name,
            "breed": dog?.breed ,
            "gender": dog?.gender,
            "bio": dog?.bio,
            "imageUrl": imageUrl
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
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
    
    

    //Collection の中のドキュメントを全て読み取る
    func getSavedDogData (completion: @escaping ([DogModel]) -> ()) {
        db.collection("users").document(uidString).collection("savedDogs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var savedDogArray = [DogModel]()
                for document in querySnapshot!.documents {
                    let dic = document.data()
                    let dog = DogModel.init(dic: dic)
                    savedDogArray.append(dog)
                    print("data name is: \(dog.name)")
                }
                completion(savedDogArray)
            }
  
        }
    }
    
    

    
    
    
    
    
}
