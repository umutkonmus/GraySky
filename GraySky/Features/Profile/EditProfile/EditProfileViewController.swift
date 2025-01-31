//
//  EditProfileViewController.swift
//  GraySky
//
//  Created by Umut Konmuş on 5.01.2025.
//

import UIKit
import FirebaseAuth

class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var currentUsername: String?
    var currentName: String?
    var currentImage: UIImage?
    var service = NetworkService()
    var isImageChanged: Bool = false
    var username: String!
    var name: String!
    var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.stopAnimating()
        setupBarButton()
        imageView.image = currentImage
        usernameTextField.text = currentUsername
        nameTextField.text = currentName
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageGestureRecognizer)
        username = service.username
        name = service.name
        addEditButton()
    }
    
    @objc func imageTapped(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        isImageChanged = true
        self.dismiss(animated: true)
    }
    
    func setupBarButton(){
        self.navigationItem.title="GraySky"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Apply", style: .done, target: self, action: #selector(performEdit))
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector(cancelEdit))
    }
    
    @objc func performEdit(){
        let isUsernameChanged = currentUsername != usernameTextField.text
        let isNameChanged = currentName != nameTextField.text
        //API CALL
        if isImageChanged || isUsernameChanged || isNameChanged{
            activityIndicator.startAnimating()
            service.editProfile(image: imageView.image!, username: (usernameTextField.text ?? service.username!), name: nameTextField.text ?? service.name!) { result, error in
                self.activityIndicator.stopAnimating()
                if error != nil {
                    self.makeAlert(message: error?.localizedDescription ?? "Error while editing profile")
                    return
                }
                //self.makeAlert(message: "Successfully edited")
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func addEditButton() {
        let buttonWidth: CGFloat = 30
        let buttonHeight: CGFloat = 30
        editButton = UIButton(type: .custom)
        editButton.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
        editButton.frame = CGRect(
            x: imageView.frame.size.width - buttonWidth - 2,
            y: imageView.frame.size.height - buttonHeight - 2,
            width: buttonWidth,
            height: buttonHeight
        )
        editButton.tintColor = .systemBlue
        editButton.addTarget(self, action: #selector(imageTapped), for: .touchUpInside)
        
        imageView.addSubview(editButton)
        }
    
    @objc func cancelEdit(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signOutClicked(_ sender: Any) {
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
