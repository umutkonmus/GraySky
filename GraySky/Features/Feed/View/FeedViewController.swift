//
//  ViewController.swift
//  GraySky
//
//  Created by Umut Konmuş on 28.12.2024.
//

import UIKit
import FirebaseAuth

class FeedViewController: UIViewController, NetworkServiceDelegate {

    let service = NetworkService()
    var data: [Entry] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "EntryCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        service.delegate = self
        
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
        makeAlert(message: error.localizedDescription)
    }
    
    
}

//MARK: TableView delegate and datasource

extension FeedViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath) as? EntryCell{

            cell.configure(with: data[indexPath.row])
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 0.2
            cell.layer.cornerRadius = 8
            cell.clipsToBounds = true
            cell.selectionStyle = .none
            
            return cell
            
        }
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
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
        
        let profileImageView = UIImageView(image: UIImage(named: "asian"))
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let profileButton = UIButton(type: .custom)
        profileButton.addSubview(profileImageView)
        profileButton.frame = profileImageView.frame
        profileButton.addTarget(self, action: #selector(profileClicked), for: .touchUpInside)
        
        let profileBarButton = UIBarButtonItem(customView: profileButton)
        self.navigationItem.leftBarButtonItem = profileBarButton
        
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
    
    @objc func profileClicked(){
        print("Profile clicked")
    }
    
}

