//
//  NetworkServiceDelegate.swift
//  GraySky
//
//  Created by Umut Konmuş on 4.01.2025.
//

protocol NetworkServiceDelegate: AnyObject{
    func didFetchData(_ data: [Entry])
    func didFailWithError(_ error: Error)
    func didFetchUser()
}
