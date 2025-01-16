//
//  BirdViewController.swift
//  GraySky
//
//  Created by Umut Konmuş on 14.01.2025.
//

import UIKit

class TwitterViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TwitterTableViewCell", bundle: nil), forCellReuseIdentifier: "TwitterCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 182
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    

}

//MARK: TableView Delegate and Datasource
extension TwitterViewController : UITableViewDelegate, UITableViewDataSource{
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterCell",for:indexPath) as? TwitterTableViewCell{
            cell.nicknameLabel.text = "@umutkonmus"
            cell.userImage.image = UIImage(named: "asian")
            cell.commentCountLabel.text = "123"
            cell.likeCountLabel.text = "124"
            cell.timeAgoLabel.text = "10h"
            cell.usernameLabel.text = "Umut Konmus"
            cell.entryText.text = "This year is amazing!"
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    
}
