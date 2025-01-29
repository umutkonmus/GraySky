//
//  SideMenuViewController.swift
//  GraySky
//
//  Created by Umut Konmuş on 21.01.2025.
//

import UIKit

class SideMenuViewController: UIViewController {

    
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var profileButton: SideMenuButton!
    @IBOutlet weak var listsButton: SideMenuButton!
    @IBOutlet weak var topicsButton: SideMenuButton!
    @IBOutlet weak var bookmarksButton: SideMenuButton!
    @IBOutlet weak var momentsButton: SideMenuButton!
    let service = NetworkService()
    
    weak var mainNavigationController: UINavigationController!
    
    init(mainNavigationController: UINavigationController) {
        
        self.mainNavigationController = mainNavigationController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = service.userImageUrl {
            profileImageView.sd_setImage(with: URL(string: url))
        }
        
        if let username = service.username {
            nicknameLabel.text = "@\(username)"
        }
        
        usernameLabel.text = "Umut Konmuş"
        followingCountLabel.text = "123"
        followerCountLabel.text = "456"
        
        let profileIcon = UIImage(named: "ProfileStroke")
        let listsIcon = UIImage(named: "ListsIcon")
        let topicsIcon = UIImage(named: "TopicsStroke")
        let bookmarksIcon = UIImage(named: "Bookmarks")
        let momentsIcon = UIImage(named: "Moments")
        
        profileButton.configure(icon: profileIcon, title: "Profile")
        listsButton.configure(icon: listsIcon, title: "Lists")
        listsButton.configure(icon: listsIcon, title: "Lists")
        topicsButton.configure(icon: topicsIcon, title: "Topics")
        bookmarksButton.configure(icon: bookmarksIcon, title: "Bookmarks")
        momentsButton.configure(icon: momentsIcon, title: "Moments")
        
        let profileImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageClicked))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(profileImageTapGestureRecognizer)
        
    }
    
    @objc func profileImageClicked() {
        showProfileVC()
    }
    
    @objc func settingsClicked() {
        print("Settings Clicked")
    }
    
    @objc func privacyClicked() {
        print("Privacy Clicked")
    }
    
    func showProfileVC(){
        mainNavigationController.performSegue(withIdentifier: "toProfileVC", sender: nil)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func moreClicked(_ sender: Any) {
    }
    @IBAction func profileClicked(_ sender: Any) {
        showProfileVC()
    }
    @IBAction func listsClicked(_ sender: Any) {
    }
    @IBAction func topicsClicked(_ sender: Any) {
    }
    @IBAction func bookmarksClicked(_ sender: Any) {
    }
    @IBAction func momentsClicked(_ sender: Any) {
    }
}
