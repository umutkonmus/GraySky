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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    //@IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var data: [Entry] = []
    
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
    
    let normalTextAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.gray,
        .font: UIFont.systemFont(ofSize: 16, weight: .regular)
    ]
    let selectedTextAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.black,
        .font: UIFont.systemFont(ofSize: 16, weight: .bold)
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        initialViewController = storyboard.instantiateViewController(withIdentifier: "PostsViewController")

        /*
        tableView.register(UINib(nibName: "TwitterTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self */
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
    
    
    func didFetchUser(user: User) {
        usernameLabel.text = user.Username
        imageView.sd_setImage(with: URL(string: user.ImageUrl))
        viewModel.fetchData(with: user.UID)
        imageView.maskCircle()
    }
    
    func setupView(){
        //Edit Button
        editButton.tintColor = viewModel.primaryColor
        editButton.layer.borderColor = viewModel.primaryColor.cgColor
        editButton.layer.borderWidth = 1
        editButton.layer.cornerRadius = editButton.frame.width / 5.8
        
        //Segmented Control
        guard let firstPage = pages.first else {return}
        setupSegmentedControl()
        
    }
    
    func setupSegmentedControl() {
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Tweets", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Replies", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Likes", at: 2, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentedControl.layer.cornerRadius = 8
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.borderColor = UIColor.gray.cgColor
        segmentedControl.clipsToBounds = true
        
        
        switchViewController(initialViewController)
        segmentedControl.addTarget(self, action: #selector(handleChange(_:)), for: .valueChanged)
    }
    
    @IBAction func editClicked(_ sender: Any) {
        performSegue(withIdentifier: "toEditView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditView"{
            if let destination = segue.destination as? EditProfileViewController{
                destination.currentImage = self.imageView.image
                destination.currentUsername = self.usernameLabel.text
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
        self.data = data
        DispatchQueue.main.async {
            //self.tableView.reloadData()
        }
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
