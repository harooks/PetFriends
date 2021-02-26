//
//  HomeViewController.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/24/21.
//

import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dogArray:[AddedDog] = []
    var dogModel = DogFirebase()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        //モデルから Firebase のデータが入った配列を取得
        dogModel.getSavedDogData { (savedDogArray) in
            self.dogArray = savedDogArray
            print("dogArray: \(self.dogArray)")  //Firebaseデータがプリントされる
            print("savedDogArray: \(savedDogArray)") //Firebaseデータがプリントされる
            print(self.dogArray[0].name)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("eh")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dogArray.count)   //Firebaseデータがプリントされない Why?
        print(dogArray)
        return dogArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = dogArray[indexPath.row].name
        return cell!
    }


}


