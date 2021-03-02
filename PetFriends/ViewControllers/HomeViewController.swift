//
//  HomeViewController.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/24/21.
//

import UIKit

import FirebaseFirestore

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dogArray:[DogModel] = []
    var dogModel = DogFirebase()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        //モデルから Firebase のデータが入った配列を取得
        dogModel.getSavedDogData { (savedDogArray) in
            self.dogArray = savedDogArray
            
  //          DispatchQueue.main.async {
                self.tableView.reloadData()
//                print("asdf count is \(self.dogArray.count)")
 //           }
            
        }
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DogTableViewCell.self, forCellReuseIdentifier: "Cell")
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return dogArray.count
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DogTableViewCell

        cell.nameTextLabel.text = self.dogArray[indexPath.row].name
  
        
        let url = URL(string: self.dogArray[indexPath.row].imageUrl )
        do {
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            cell.dogImageView.image = image
            print("success")
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        
        return cell

    }
}


