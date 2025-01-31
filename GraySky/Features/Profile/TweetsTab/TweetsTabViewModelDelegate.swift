//
//  TweetsTabViewModelDelegate.swift
//  GraySky
//
//  Created by Umut Konmuş on 29.01.2025.
//

protocol TweetsTabViewModelDelegate : AnyObject {
    func fetchData()
    func didFetchData(_ data: [Entry])
}
