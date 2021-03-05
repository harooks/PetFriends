//
//  HomeViewController.swift
//  PetFriends
//
//  Created by Haruko Okada on 2/24/21.
//

import UIKit

import Firebase
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dogArray:[DogModel] = []
    var dogModel = DogFirebase()
    
    @IBOutlet weak var tableView: UITableView!
  
    override func viewWillAppear(_ animated: Bool) {
        //モデルから Firebase のデータが入った配列を取得
        
        dogModel.getSavedDogData { (savedDogArray) in
            self.dogArray = savedDogArray
            self.tableView.reloadData()
        }

    }
    
    override func viewDidLoad() {
        
//        super.viewDidLoad()
      self.navigationController?.isNavigationBarHidden = true
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.register(DogTableViewCell.self, forCellReuseIdentifier: "Cell")
//        DispatchQueue.main.async {
            self.tableView.reloadData()
//        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
  //      return dogArray.count
        print("count of Array :\(dogArray.count)")
        return dogArray.count
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DogTableViewCell

        print("names in array is: \(dogArray[indexPath.row].name)")
        cell.nameLabel.text = self.dogArray[indexPath.row].name


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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
         tableView.deselectRow(at: indexPath, animated: true)

//        let editVC = EditDogViewController()
        let editVC = storyboard?.instantiateViewController(identifier: "EditVC") as! EditDogViewController
        
        //show image in edit VC
//        let url = URL(string: self.dogArray[indexPath.row].imageUrl )
//        do {
//            let data = try Data(contentsOf: url!)
//            let image = UIImage(data: data)
//            editVC.dogImageView.image = image
//            print("success")
//        } catch let err {
//            print("Error : \(err.localizedDescription)")
//        }
        
        //show name and other texts
        editVC.newName = dogArray[indexPath.row].name
        editVC.newBreed = dogArray[indexPath.row].breed
        editVC.newOther = dogArray[indexPath.row].bio
        editVC.newGender = dogArray[indexPath.row].gender
        editVC.documentId = dogArray[indexPath.row].id
        
        print("imageURL is: \(dogArray[indexPath.row].imageUrl)")
        editVC.newImageUrl = dogArray[indexPath.row].imageUrl

        //get document id, store doc id in view controller. クリックしたやつのドキュメントIDをとってくる
       
        DispatchQueue.main.async {
        self.navigationController?.pushViewController(editVC, animated: true)
        }
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
}


}
