//
//  LoginViewModel.swift
//  GraySky
//
//  Created by Umut Konmuş on 27.01.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class LoginViewModel {
    
    
    weak var delegate: LoginViewModelDelegate?
    var email: String = ""
    
    func singInOrCreateUser(email: String, password: String){
        if email != "" && password != ""{
            self.email = email
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let error = error {

                    if let authError = error as? NSError, authError.code == AuthErrorCode.invalidCredential.code.rawValue {
                        
                        self.createUser(email: email, password: password)
                        
                    } else {
                        // If not user not found error
                        self.delegate?.makeAlert(message: error.localizedDescription)
                    }
                } else {
                    // User Exists
                    self.delegate?.logged()
                }
            }
        } else {
            self.delegate?.makeAlert(message: "Lütfen email ve parolayı boş bırakmayınız.") }
        }
        
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                
                self.delegate?.makeAlert(message: error.localizedDescription)
                
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
        
        let userInfoData: [String: Any] = [
            "imageUrl": imageUrl,
            "name": "",
            "username": self.email
        ]
        
        db.collection("UserInfo").document(userId).setData(userInfoData) { error in
            if let error = error {
                self.delegate?.makeAlert(message: "Veri eklenirken hata oluştu: \(error.localizedDescription)")
            } else {
                // Successfulyy Uploaded
                self.delegate?.logged()
            }
        }
    }
}

