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
        
        let sideMenuVC = SideMenuViewController(mainNavigationController: self.navigationController!)
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "LeftArrowIcon"), for: .normal)
        backButton.tintColor = .white
        backButton.backgroundColor = .black
        backButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        backButton.layer.cornerRadius = 18 
        backButton.clipsToBounds = true
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)

        // Custom UIBarButtonItem olarak ayarla
        let barButtonItem = UIBarButtonItem(customView: backButton)

        // Back button'u navigation item'a ekle
        navigationItem.backBarButtonItem = barButtonItem

        
        sideMenu = SideMenuNavigationController(rootViewController: sideMenuVC)
        sideMenu?.leftSide = true
        sideMenu?.menuWidth = UIScreen.main.bounds.width * 0.8
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        
        let slideRightGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSlideRight(_:)))
        view.addGestureRecognizer(slideRightGestureRecognizer)
        
        setupFloatingButton()
    }
    
    @objc func handleSlideRight(_ gesture: UIPanGestureRecognizer)  {
        let translation = gesture.translation(in: view)
        
        if translation.x > 0 {
            openSideMenu()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        service.fetchData()
        setupNavigation()
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
        let profileImageView = ProfileImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        profileImageView.sd_setImage(with: URL(string: service.userImageUrl!))
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        //profileImageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let profileButton = UIButton(type: .custom)
        profileButton.addSubview(profileImageView)
        profileButton.frame = profileImageView.frame
        profileButton.addTarget(self, action: #selector(openSideMenu), for: .touchUpInside)
        
        let profileBarButton = UIBarButtonItem(customView: profileButton)
        self.navigationItem.leftBarButtonItem = profileBarButton
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupFloatingButton(){
        let floatingButton = UIButton(type: .system)
        let floatingButtonImage = UIImage(named: "AddText")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))
        floatingButton.setImage(floatingButtonImage, for: .normal)
        floatingButton.backgroundColor = UIColor(hex: "4C9EEB")
        floatingButton.tintColor = .white
        floatingButton.layer.cornerRadius = 30 // Çap / 2
        floatingButton.layer.shadowColor = UIColor.black.cgColor
        floatingButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        floatingButton.layer.shadowOpacity = 0.3
        floatingButton.layer.shadowRadius = 4
        
        // Buton boyutlarını ayarla
        floatingButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        // Butonu view'e ekle
        view.addSubview(floatingButton)
        
        // Auto Layout ile konumlandırma
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -11),
            floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -11),
            floatingButton.widthAnchor.constraint(equalToConstant: 56),
            floatingButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        // Butona tıklanma aksiyonu ekle
        floatingButton.addTarget(self, action: #selector(toNewEntry), for: .touchUpInside)
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
    func setupNavigation(){
        
        let appIconImageView = UIImageView(image: UIImage(named: "graysky"))
        appIconImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = appIconImageView

        // Auto layout
        appIconImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            appIconImageView.widthAnchor.constraint(equalToConstant: 22),
            appIconImageView.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "FeatureStroke"), for: .normal)
        button.contentMode = .scaleAspectFit
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 27),
            button.heightAnchor.constraint(equalToConstant: 27)
        ])
       
        button.addTarget(self, action: #selector(topicsClicked), for: .touchUpInside)

       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        /*
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(toNewEntry))
        self.navigationItem.rightBarButtonItem = addButton*/
            
    }
    
    @objc func topicsClicked(){
        print("Topics Clicked")
    }
    
    @objc func toNewEntry(){
        performSegue(withIdentifier: "toNewEntry", sender: nil)
    }
    
    @objc func openSideMenu(){
        present(sideMenu!,animated: true)
    }
    
}
