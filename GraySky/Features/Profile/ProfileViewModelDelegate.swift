//
//  ProfileViewModelDelegate.swift
//  GraySky
//
//  Created by Umut Konmuş on 27.01.2025.
//

import Foundation

protocol ProfileViewModelDelegate : AnyObject {
    func didFetchData(_ data: [Entry])
    func didFailWithError(_ error: any Error)
    func didFetchUser(user: User)
    func makeAlert(message: String)
    func setupView()
}
