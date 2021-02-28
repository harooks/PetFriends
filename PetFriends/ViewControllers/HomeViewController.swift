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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
      
        }
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("eh")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DogTableViewCell.self, forCellReuseIdentifier: "Cell")
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return dogArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DogTableViewCell
        print(dogArray.count)
        print(dogArray[indexPath.row].name)
   //     cell?.textLabel?.text = self.dogArray[indexPath.row].name
        return cell

    }


}


