//
//  Entry.swift
//  GraySky
//
//  Created by Umut Konmuş on 30.12.2024.
//

import Foundation
import UIKit

struct Entry : Codable{
    let documentId: String
    let date: Date
    let userName: String
    let userUsername: String
    let userText: String
    let userImageUrl: String
    let timeAgo: String
    let isRepublished: Bool
    let isLiked: Bool
    let likeCount: Int
    let commentCount: Int
    let republishedCount: Int
}
