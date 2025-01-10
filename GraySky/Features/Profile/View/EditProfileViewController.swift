//
//  EditProfileViewController.swift
//  GraySky
//
//  Created by Umut Konmuş on 5.01.2025.
//

import UIKit

class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var currentUsername: String?
    var currentImage: UIImage?
    var service = NetworkService()
    var isImageChanged: Bool = false
    var isUsernameChanged: Bool = false
    var username: String!
    var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.stopAnimating()
        setupBarButton()
        imageView.image = currentImage
        usernameTextField.text = currentUsername
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageGestureRecognizer)
        username = service.username
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
        isUsernameChanged = username == usernameTextField.text
        //API CALL
        if isImageChanged || isUsernameChanged{
            activityIndicator.startAnimating()
            service.editProfile(image: imageView.image!, username: (usernameTextField.text ?? service.username!)) { result, error in
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

}
