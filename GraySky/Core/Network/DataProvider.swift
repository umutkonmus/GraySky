//
//  DataProvider.swift
//  GraySky
//
//  Created by Umut Konmuş on 30.12.2024.
//

import Foundation

protocol DataProvider{
    var user: User? {get}
    func fetchData()
    func fetchData(with userId: String)
}
extension DataProvider{
    func fetchData(with userId: String){
        
    }
    
    func didFetchUser(){
        
    }
}
