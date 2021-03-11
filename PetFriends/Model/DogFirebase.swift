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
    let saveData = UserDefaults.standard
    
    
    func createNewAccount(email: String, password: String, myDog: MyDogStruct, view: UIImageView) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            if err != nil {
                
                print("error creating user: \(err)")
            } else {
                
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
 
                        let ref = self.db.collection("users").document(result!.user.uid).collection("registeredDogs")
                        let id = ref.document().documentID
                        self.saveData.setValue(id, forKey: "dogId")
                        
                        self.db.collection("users").document(result!.user.uid).setData(["id" : id])
                        
                        
                        let someData = [
                            "name": myDog.name,
                            "breed": myDog.breed,
                            "gender": myDog.gender,
                            "bio": myDog.bio,
                            "imageUrl": urlString,
                            "id": id
                        ] as [String : Any]
                        
                        ref.document(id).setData(someData, merge: true)
                        
                        print("register Dog ran without error?")
    
                    }
                }
                print("Document successfully written!")
        }
    }
}

   

    func getDogData(dog: AddedDogStruct?, imageUrl: String) {
        uidString = String(currentUser!.uid)
        let ref = db.collection("users").document(uidString).collection("savedDogs")
        let id = ref.document().documentID

        let someData = [
            "id": id,
            "name": dog?.name,
            "breed": dog?.breed,
            "gender": dog?.gender,
            "bio": dog?.bio,
            "fav": dog?.fav,
            "imageUrl": imageUrl,
            "created": Timestamp(date: Date())
        ] as [String : Any]
        
        ref.document(id).setData(someData, merge: true)
    }
    
    func updatedMyDogData(id: String, name: String, breed: String, bio: String, gender: Bool, imageUrl: String) {
        uidString = String(currentUser!.uid)
        let ref = db.collection("users").document(uidString).collection("registeredDogs")
        
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
    
    
    func updateMyDogImage(id: String, name: String, breed: String, bio: String, gender: Bool, view: UIImageView) {
        
        guard let imageData = view.image?.jpegData(compressionQuality: 0.75) else {
            print("not working")
            return}
        
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
                let ref = self.db.collection("users").document(self.uidString).collection("registeredDogs").document(id)
                print("path to this data is1 \(ref.path)")
                
                let someData = [
                    "id": id, //まだ保存前だから nil になってしまう
                    "name": name,
                    "breed": breed,
                    "gender": gender,
                    "bio": bio,
                    "imageUrl": urlString,
                ] as [String : Any]
                
                ref.updateData(someData)
                print("path to this data is \(ref.path)")
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

    

    func updateData(id: String, name: String, breed: String, bio: String, gender: Bool, fav: Bool, imageUrl: String) {
        uidString = String(currentUser!.uid)
        let ref = db.collection("users").document(uidString).collection("savedDogs")
        
        let someData = [
            "id": id, //まだ保存前だから nil になってしまう
            "name": name,
            "breed": breed,
            "gender": gender,
            "bio": bio,
            "fav": fav,
            "imageUrl": imageUrl,
        ] as [String : Any]
        
        ref.document(id).updateData(someData)
        
    }
    
    
    
    func updateImage(id: String, name: String, breed: String, bio: String, gender: Bool, fav: Bool, view: UIImageView) {
        guard let imageData = view.image?.jpegData(compressionQuality: 0.75) else {
            print("not working")
            return}
        
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
                    "fav": fav,
                    "imageUrl": urlString,
                ] as [String : Any]
                
                ref.document(id).updateData(someData)

            }
        }
    }
    
    
    func login(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) {(result, error) in
            
            if error != nil {
                //couldn't login
//                showError(_message: "メールかパスワードが違います")
            } else {

                self.db.collection("users").document(result!.user.uid).getDocument {(document, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let id = document?.get("id")
                        self.saveData.setValue(id, forKey: "dogId")
                        print("login saved id is \(id)")
                    }
                }

            }
        }
    }
    
    func getSavedDogData (completion: @escaping ([DogModel]) -> ()) {
        
        uidString = String(currentUser!.uid)
        var savedDogArray = [DogModel]()
        db.collection("users").document(uidString).collection("savedDogs").order(by: "created").getDocuments { (querySnapshot, err) in
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
    
    
    func getRegisteredDogData (completion: @escaping (RegisteredDogModel) -> ()) {
        let myDogId = saveData.object(forKey: "dogId") as! String
        
        uidString = String(currentUser!.uid)
        db.collection("users").document(uidString).collection("registeredDogs").document(myDogId).getDocument { (document, error) in
            if let document = document, document.exists {
                let dic = document.data()
                let dog = RegisteredDogModel.init(dic: dic!)
                print("Document data: \(dog)")
                completion(dog)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    func deleteDocument(documentId: String) {
        uidString = String(currentUser!.uid)
        db.collection("users").document(uidString).collection("savedDogs").document(documentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

}
