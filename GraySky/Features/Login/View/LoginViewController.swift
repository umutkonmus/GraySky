//
//  LoginViewController.swift
//  GraySky
//
//  Created by Umut Konmuş on 31.12.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordText.isSecureTextEntry = true
    }
    
    @IBAction func singInClicked(_ sender: Any) {
        /*
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                if error != nil{
                    self.makeAlert(message: error?.localizedDescription ?? "Can't login")
                }
                else{
                    self.performSegue(withIdentifier: "toMainApp", sender: nil)
                }
            }*/
        if emailText.text != "" && passwordText.text != "" {
            singInOrCreateUser(email: emailText.text!,password: passwordText.text!)
        }else{
            makeAlert(message: "Email or password can not be empty")
        }
        
    }
    
    func singInOrCreateUser(email: String, password: String){
        
            
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    // Eğer hata varsa ve kullanıcı bulunamadıysa, yeni kullanıcı oluşturalım
                    if let authError = error as? NSError, authError.code == AuthErrorCode.invalidCredential.code.rawValue {
                        
                        self.createUser(email: email, password: password)
                        
                    } else {
                        // If not user not found error
                        self.makeAlert(message: error.localizedDescription)
                    }
                } else {
                    // User Exists
                    self.performSegue(withIdentifier: "toMainApp", sender: nil)
                }
            }
        
        
    }
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                
                self.makeAlert(message: error.localizedDescription)
                
            } else {
                
                guard let user = authResult?.user else { return }
                self.addUserImageToFirestore(userId: user.uid)
            }
        }
    }
    
    func addUserImageToFirestore(userId: String) {
        print("User ID: \(userId)")
        let db = Firestore.firestore()
        
        let imageUrl = "https://firebasestorage.googleapis.com/v0/b/graysky-e3186.firebasestorage.app/o/media%2FC453330A-011D-41D3-9681-94C945A3E579.jpeg?alt=media&token=0347e80e-adaf-48ca-ac08-ba3f2b7a9ec4"
        
        let userImageData: [String: Any] = [
            "imageUrl": imageUrl,
            "username": emailText.text!
        ]
        
        db.collection("UserImages").document(userId).setData(userImageData) { error in
            if let error = error {
                // Veritabanına veri eklerken hata oluştu
                self.makeAlert(message: "Veri eklenirken hata oluştu: \(error.localizedDescription)")
            } else {
                // Veri başarıyla eklendi
                self.performSegue(withIdentifier: "toMainApp", sender: nil)
            }
        }
    }
    
}
