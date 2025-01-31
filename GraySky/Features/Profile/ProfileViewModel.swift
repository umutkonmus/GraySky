//
//  ProfileViewModel.swift
//  GraySky
//
//  Created by Umut Konmuş on 26.01.2025.
//
import UIKit

class ProfileViewModel : NetworkServiceDelegate{
    
    weak var delegate: ProfileViewModelDelegate?
    
    var primaryColor : UIColor {
        return ThemeManager.primaryColor
    }
    
    var secondaryColor : UIColor {
        return ThemeManager.secondaryColor
    }
    
    let service = NetworkService()
    
    init() {
        service.delegate = self
    }
    
    func fetchData(with UID: String) {
        service.fetchData(with: UID)
    }
    
    func didFetchData(_ data: [Entry]) {
        delegate?.didFetchData(data)
    }
    
    func didFailWithError(_ error: any Error) {
        delegate?.didFailWithError(error)
    }
    
    func didFetchUser(user: User) {
        delegate?.didFetchUser(user: user)
    }
    
    func deleteEntry(documentId: String) {
        service.deleteEntry(documentId: documentId) {  result, error in
            if error != nil{
                self.delegate?.makeAlert(message: error!.localizedDescription)
                return
            }
            if result == true{
                self.delegate?.makeAlert(message: "Deleted")
                self.delegate?.setupView()
            }
        }
    }
}
