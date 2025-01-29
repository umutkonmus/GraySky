//
//  LoginViewModelDelegate.swift
//  GraySky
//
//  Created by Umut Konmuş on 27.01.2025.
//

protocol LoginViewModelDelegate : AnyObject{
    func signInOrCreateUser()
    func createUser(email: String, password: String)
    func addUserImageToFirestore(userId: String)
    func makeAlert(message: String)
    func logged()
}

extension LoginViewModelDelegate {
    func signInOrCreateUser() {
        
    }
    
    func createUser(email: String, password: String) {
        
    }
    
    func addUserImageToFirestore(userId: String) {
        
    }
}
