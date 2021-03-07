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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var dogArray:[DogModel] = []
    var filteredDogArray:[DogModel] = []
    var dogFirebase = DogFirebase()
    var isFiltering:Bool = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var tableView: UITableView!
  
    override func viewWillAppear(_ animated: Bool) {
        //モデルから Firebase のデータが入った配列を取得
        
        dogFirebase.getSavedDogData { (savedDogArray) in
            self.dogArray = savedDogArray
            self.dogArray.reverse()
            self.tableView.reloadData()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.navigationController?.isNavigationBarHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
//        tableView.register(DogTableViewCell.self, forCellReuseIdentifier: "Cell")
//        DispatchQueue.main.async {
            self.tableView.reloadData()
//        }
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        
    }
    

 //Search bar realted functions---------
 
     //  検索バーに入力があったら呼ばれる
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filteredDogArray = dogArray
        isFiltering = true
        filteredDogArray = []
        
        if searchText == "" {
            filteredDogArray = dogArray
        } else {
            for dog in dogArray {
                if dog.name.lowercased().contains(searchText.lowercased()) {
                    filteredDogArray.append(dog)
                    print("filtered dogs name isssss \(dog.name)")
                }
            }
        }
        
        tableView.reloadData()
//        searchBar.resignFirstResponder()
        print("filtered array isssss \(filteredDogArray)")

     }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
  //      return dogArray.count
        if isFiltering {
              return filteredDogArray.count
          } else {
              return dogArray.count
          }
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DogTableViewCell

        if isFiltering {
            cell.nameLabel.text = self.filteredDogArray[indexPath.row].name
            let url = URL(string: self.filteredDogArray[indexPath.row].imageUrl)
            do {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                cell.dogImageView.image = image
                print("success")
            } catch let err {
                print("Error : \(err.localizedDescription)")
            }
            if filteredDogArray[indexPath.row].fav == true {
                cell.heartImageView.isHidden = false
                cell.heartImageView.image = UIImage(named: "heart")
            } else {
                cell.heartImageView.isHidden = true
            }
            
        } else {
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
            if dogArray[indexPath.row].fav == true {
                cell.heartImageView.image = UIImage(named: "heart")
                cell.heartImageView.isHidden = false
            } else {
                cell.heartImageView.isHidden = true
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }

    //スワイプしたセルを削除　※arrayNameは変数名に変更してください
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let documentId = dogArray[indexPath.row].id
            dogFirebase.deleteDocument(documentId: documentId)
            dogArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
         tableView.deselectRow(at: indexPath, animated: true)

//        let editVC = EditDogViewController()
        let editVC = storyboard?.instantiateViewController(identifier: "EditVC") as! EditDogViewController
        
        editVC.newName = dogArray[indexPath.row].name
        editVC.newBreed = dogArray[indexPath.row].breed
        editVC.newOther = dogArray[indexPath.row].bio
        print("bio saved is: \(editVC.newOther)")
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
