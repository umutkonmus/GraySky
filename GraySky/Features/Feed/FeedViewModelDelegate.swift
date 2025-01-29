//
//  FeedViewModelDelegate.swift
//  GraySky
//
//  Created by Umut Konmuş on 27.01.2025.
//

import Foundation

protocol FeedViewModelDelegate: AnyObject {
    func didFetchUser(user: User)
    func didFetchData(_ data: [Entry])
    func didFailWithError(_ error: Error)
}
