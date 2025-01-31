//
//  TweetsTabViewModel.swift
//  GraySky
//
//  Created by Umut Konmuş on 29.01.2025.
//

class TweetsTabViewModel : NetworkServiceDelegate {
    
    var data: [Entry] = []
    weak var delegate: TweetsTabViewModelDelegate?
    
    let service = NetworkService()
    
    init(){
        service.delegate = self
    }
    
    func fetchData(){
        if let user = service.user {
            service.fetchData(with: user.UID)
        }
    }
    
    func didFetchData(_ data: [Entry]) {
        self.data = data
        delegate?.didFetchData(data)
    }
    
    func didFailWithError(_ error: any Error) {
        
    }
    
    func didFetchUser(user: User) {
        fetchData()
    }
}
