//
//  ProfileViewController.swift
//  GraySky
//
//  Created by Umut Konmuş on 31.12.2024.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, ProfileViewModelDelegate{
    
    private let viewModel = ProfileViewModel()

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var customSegmentedControl: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    //@IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    private let twSegmentedControl: UISegmentedControl = {
        let items = ["Tweets", "Replies", "Likes"]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.selectedSegmentTintColor = .clear
        sc.setTitleTextAttributes([.foregroundColor: ThemeManager.primaryColor, .font: UIFont.boldSystemFont(ofSize: 16)], for: .selected)
        sc.setTitleTextAttributes([.foregroundColor: ThemeManager.secondaryColor, .font: UIFont.systemFont(ofSize: 16, weight: .semibold)], for: .normal)
        sc.backgroundColor = .clear
        sc.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        sc.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        return sc
    }()
    
    var pageViewController : UIPageViewController?
    var currentIndex = 0
    
    var initialViewController : UIViewController!
    
    var pages: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return [
            storyboard.instantiateViewController(withIdentifier: "PostsViewController"),
            storyboard.instantiateViewController(withIdentifier:"RepliesViewController"),
            storyboard.instantiateViewController(withIdentifier:"LikesViewController")
        ]
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        initialViewController = storyboard.instantiateViewController(withIdentifier: "PostsViewController")
    }
    
    func switchViewController(_ viewController: UIViewController) {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        addChild(viewController)
        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    @objc func handleChange(_ sender: UISegmentedControl){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var selectedViewController: UIViewController
        
        switch sender.selectedSegmentIndex {
        case 0:
            selectedViewController = storyboard.instantiateViewController(withIdentifier: "PostsViewController")
        case 1:
            selectedViewController = storyboard.instantiateViewController(withIdentifier: "RepliesViewController")
        case 2:
            selectedViewController = storyboard.instantiateViewController(withIdentifier: "LikesViewController")
        default:
            return
        }
        
        switchViewController(selectedViewController)
    }
    
    func getJoinedDateString(date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        return "Joined \(month) \(year)"
    }
    
    
    func didFetchUser(user: User) {
        nameLabel.text = user.Name
        usernameLabel.text = "@\(user.Username)"
        bioLabel.text = user.Biography
        linkLabel.text = user.Link
        calendarLabel.text = getJoinedDateString(date: user.JoinDate)
        followersCountLabel.text = String(user.FollowerCount)
        followingCountLabel.text = String(user.FollowingCount)
        imageView.sd_setImage(with: URL(string: user.ImageUrl))
        bannerImageView.sd_setImage(with: URL(string: user.BannerUrl))
        viewModel.fetchData(with: user.UID)
        imageView.maskCircle()
    }
    
    func setupView(){
        linkLabel.textColor = viewModel.primaryColor
        calendarLabel.textColor = viewModel.secondaryColor
        usernameLabel.textColor = viewModel.secondaryColor
        
        //Edit Button
        editButton.tintColor = viewModel.primaryColor
        editButton.layer.borderColor = viewModel.primaryColor.cgColor
        editButton.layer.borderWidth = 1
        editButton.layer.cornerRadius = editButton.frame.width / 6
        
        setupSegmentedControl()
        
    }
    
    func setupSegmentedControl() {
        guard let _ = pages.first else {return}
        
        customSegmentedControl.addSubview(twSegmentedControl)
        
        twSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            twSegmentedControl.trailingAnchor.constraint(equalTo: customSegmentedControl.trailingAnchor),
            twSegmentedControl.leadingAnchor.constraint(equalTo: customSegmentedControl.leadingAnchor),
            twSegmentedControl.topAnchor.constraint(equalTo: customSegmentedControl.topAnchor),
            twSegmentedControl.bottomAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor)
        ])
        
        switchViewController(initialViewController)
        twSegmentedControl.addTarget(self, action: #selector(handleChange), for: .valueChanged)
    }
    
    @IBAction func editClicked(_ sender: Any) {
        performSegue(withIdentifier: "toEditView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditView"{
            if let destination = segue.destination as? EditProfileViewController{
                destination.currentImage = self.imageView.image
                destination.currentUsername = self.viewModel.service.user?.Username
                destination.currentName = self.nameLabel.text
            }
        }
    }
    
    func showOptionsMenu(documentId: String) {
        let alertController = UIAlertController(title: "Options", message: "Select an option", preferredStyle: .actionSheet)

        let delete = UIAlertAction(title: "Delete", style: .default) { _ in
            self.deleteAction(id: documentId)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(delete)
        alertController.addAction(cancel)

        self.present(alertController, animated: true, completion: nil)
    }

    func deleteAction(id: String) {
        viewModel.deleteEntry(documentId: id)
    }
    
    func didFetchData(_ data: [Entry]) {
    }
    
    func didFailWithError(_ error: any Error) {
        makeAlert(message: error.localizedDescription)
    }
    
    
    //MARK: Sign Out
    @objc func signOutClicked(){
        do{
            try Auth.auth().signOut()
            navigateToLoginScreen()
        }catch let error{
            makeAlert(message: error.localizedDescription)
        }
    }
    
    func navigateToLoginScreen() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                
                sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: loginVC)
                
                UIView.transition(with: sceneDelegate.window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
    }
    
}
/*
//MARK: TableView delegate and datasource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath) as? TwitterTableViewCell{
            /*
            cell.configure(with: data[indexPath.row])
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 0.2
            cell.layer.cornerRadius = 8
            cell.clipsToBounds = true
            cell.selectionStyle = .none
             */
            cell.configure(with: data[indexPath.row])
            cell.layer.borderColor = UIColor.black.cgColor
            cell.selectionStyle = .none
            return cell
            
        }
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}
*/
