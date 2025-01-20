//
//  BirdViewController.swift
//  GraySky
//
//  Created by Umut Konmuş on 14.01.2025.
//

import UIKit
import SideMenu

class FeedViewController: UIViewController, NetworkServiceDelegate{

    let service = NetworkService()
    var sideMenu: SideMenuNavigationController?
    var data: [Entry] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TwitterTableViewCell", bundle: nil), forCellReuseIdentifier: "TwitterCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 182
        tableView.delegate = self
        tableView.dataSource = self
        service.delegate = self
        
        let sideMenuVC = SideMenuViewController()
        sideMenu = SideMenuNavigationController(rootViewController: sideMenuVC)
        sideMenu?.leftSide = true
        sideMenu?.menuWidth = UIScreen.main.bounds.width * 0.8
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        
        let slideRightGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(openSideMenu))
        view.addGestureRecognizer(slideRightGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        service.fetchData()
        setupTabBar()
        setupBarButton()
    }
    
    func didFetchData(_ data: [Entry]) {
        self.data = data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(_ error: any Error) {
        print("failed with error")
        makeAlert(message: error.localizedDescription)
    }
    
    func didFetchUser(){
        let profileImageView = UIImageView()
        profileImageView.sd_setImage(with: URL(string: service.userImageUrl!))
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let profileButton = UIButton(type: .custom)
        profileButton.addSubview(profileImageView)
        profileButton.frame = profileImageView.frame
        profileButton.addTarget(self, action: #selector(openSideMenu), for: .touchUpInside)
        
        let profileBarButton = UIBarButtonItem(customView: profileButton)
        self.navigationItem.leftBarButtonItem = profileBarButton
    }
    

}

//MARK: TableView Delegate and Datasource
extension FeedViewController : UITableViewDelegate, UITableViewDataSource{
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterCell",for:indexPath) as? TwitterTableViewCell{
            /*
            cell.nicknameLabel.text = "@umutkonmus"
            cell.userImage.image = UIImage(named: "asian")
            cell.commentCountLabel.text = "123"
            cell.likeCountLabel.text = "124"
            cell.timeAgoLabel.text = "10h"
            cell.usernameLabel.text = "Umut Konmus"
            cell.entryText.text = "This year is amazing!"
             */
            
            cell.configure(with: data[indexPath.row])
            cell.layer.borderColor = UIColor.black.cgColor
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    
}


//MARK: Additional Setup

extension FeedViewController{
    func setupTabBar(){
        tabBarItem.image = UIImage(systemName: "house.fill")
    }
    func setupBarButton(){/*
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"asian"), style:.plain, target: self, action: #selector(barButtonProfileClicked))
        self.navigationItem.title = "GraySky"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "plus.app"), style: .done, target: self, action: #selector(toNewEntry))
        */
        
        let appIconImageView = UIImageView(image: UIImage(named: "graysky"))
        appIconImageView.contentMode = .scaleAspectFit
        appIconImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.navigationItem.titleView = appIconImageView
        
       
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(toNewEntry))
        self.navigationItem.rightBarButtonItem = addButton
            
    }
    
    @objc func toNewEntry(){
        performSegue(withIdentifier: "toNewEntry", sender: nil)
    }
    
    @objc func openSideMenu(){
        present(sideMenu!,animated: true)
    }
    
}
