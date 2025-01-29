//
//  FeedViewModel.swift
//  GraySky
//
//  Created by Umut Konmuş on 27.01.2025.
//
import Foundation

class FeedViewModel : NetworkServiceDelegate {
    
    weak var delegate: FeedViewModelDelegate?
    let service = NetworkService()
    
    init() {
        service.delegate = self
    }
    
    func fetchData(){
        service.fetchData()
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
    
    
}
