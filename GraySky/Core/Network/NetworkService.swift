//
//  NetworkService.swift
//  GraySky
//
//  Created by Umut Konmuş on 30.12.2024.
//

import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class NetworkService : DataProvider{
    
    //static let shared = NetworkService()
    
    weak var delegate: NetworkServiceDelegate?
    private let db = Firestore.firestore()
    
    var userUID: String?
    var username: String?
    var userImageUrl: String?
    var name: String?
    var bannerUrl: String?
    var biography: String?
    var link: String?
    var followers: [String]?
    var following: [String]?
    var joinDate: Date?
    
    var user: User?
    
    init() {
        self.userUID = Auth.auth().currentUser!.uid
        getLoggedUserFromDatabase()
    }
    
    func getLoggedUserFromDatabase(){
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("UserInfo").document(userUID!).getDocument() { snapshot, error in
            if let error = error {
                self.delegate?.didFailWithError(error)
                return
            }
            if let snapshot = snapshot {
                self.username = snapshot.get("username") as? String
                self.name = snapshot.get("name") as? String
                self.userImageUrl = snapshot.get("imageUrl") as? String
                self.bannerUrl = snapshot.get("bannerUrl") as? String
                self.biography = snapshot.get("biography") as? String
                self.link = snapshot.get("link") as? String
                self.followers = snapshot.get("followers") as? [String]
                self.following = snapshot.get("following") as? [String]
                let joinDate = snapshot.get("joinDate") as? Timestamp
                self.joinDate = joinDate?.dateValue()
                
                if let uid = self.userUID {
                    if let name = self.name {
                        if let username = self.username {
                            if let imageUrl = self.userImageUrl {
                                if let bannerUrl = self.bannerUrl {
                                    if let biography = self.biography {
                                        if let link = self.link {
                                            if let followersCount = self.followers?.count {
                                                if let followingCount = self.following?.count {
                                                    if let date = self.joinDate {
                                                        self.user = User(
                                                            UID: uid,
                                                            Name: name,
                                                            Username: username,
                                                            ImageUrl: imageUrl,
                                                            BannerUrl: bannerUrl,
                                                            Biography: biography,
                                                            Link:link,
                                                            FollowerCount: followersCount,
                                                            FollowingCount: followingCount,
                                                            JoinDate: date
                                                        )
                                                        self.delegate?.didFetchUser(user: self.user!)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    func fetchData() {
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Entries").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                self.delegate?.didFailWithError(error)
                return
            }
            
            if let snapshot = snapshot {
                
                var data: [Entry] = []
                let dispatchGroup = DispatchGroup()
                
                for document in snapshot.documents{
                    let documentId = document.documentID
                    let userText = document.get("text") as! String
                    let publisherUID = document.get("publisherUID") as! String
                    let likedBy = document.get("likedBy") as? [String] ?? []
                    let likeCount = likedBy.count
                    let republishedBy = document.get("republishedBy") as? [String] ?? []
                    let republishedCount = republishedBy.count
                    let comments = document.get("comments") as? [String] ?? []
                    let commentsCount = comments.count
                    let isLiked = likedBy.contains(self.userUID ?? "")
                    let isRepublished = republishedBy.contains(self.userUID ?? "")
                    
                    let date = document.get("date") as! Timestamp
                    let differenceFromNow = self.differenceFromNow(timestamp: date.dateValue())
                    
                    dispatchGroup.enter()
                    
                    let imageRef = firestoreDatabase.collection("UserInfo").document(publisherUID)
                    imageRef.getDocument { snapshot, error in
                        
                        defer {
                            dispatchGroup.leave()
                        }
                        
                        if let error = error {
                            self.delegate?.didFailWithError(error)
                        }
                        
                        if let snapshot = snapshot {
                            let imageUrl = snapshot.get("imageUrl") as! String
                            let name = snapshot.get("name") as! String
                            let username = snapshot.get("username") as! String
                            let entry = Entry(documentId: documentId,
                                              date: date.dateValue(),
                                              userName: username,
                                              userUsername: name,
                                              userText: userText,
                                              userImageUrl: imageUrl,
                                              timeAgo: differenceFromNow,
                                              isRepublished: isRepublished,
                                              isLiked: isLiked,
                                              likeCount: likeCount,
                                              commentCount: commentsCount,
                                              republishedCount: republishedCount)
                            data.append(entry)
                        }
                    }
                    
                }
                dispatchGroup.notify(queue: .main){
                    data.sort { $0.date > $1.date }
                    self.delegate?.didFetchData(data)
                }
            }
            
        }
        
    }
    
    func fetchData(with userId: String) {
        let firestoreDatabase = Firestore.firestore()

        firestoreDatabase.collection("Entries")
            .whereField("publisherUID", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    self.delegate?.didFailWithError(error)
                    return
                }
                
                guard let snapshot = snapshot else {
                    self.delegate?.didFailWithError(NSError(domain: "SnapshotError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No snapshot found"]))
                    return
                }
                
                var data: [Entry] = []
                let dispatchGroup = DispatchGroup()
                
                for document in snapshot.documents {
                    
                    let documentId = document.documentID
                    let userText = document.get("text") as? String ?? ""
                    let publisherUID = document.get("publisherUID") as? String ?? ""
                    let likedBy = document.get("likedBy") as? [String] ?? []
                    let likeCount = likedBy.count
                    let republishedBy = document.get("republishedBy") as? [String] ?? []
                    let republishedCount = republishedBy.count
                    let comments = document.get("comments") as? [String] ?? []
                    let commentsCount = comments.count
                    let isLiked = likedBy.contains(self.userUID ?? "")
                    let isRepublished = republishedBy.contains(self.userUID ?? "")
                    
                    let date = document.get("date") as! Timestamp
                    let differenceFromNow = self.differenceFromNow(timestamp: date.dateValue())
                    
                    dispatchGroup.enter()
                    
                    let imageRef = firestoreDatabase.collection("UserInfo").document(publisherUID)
                    imageRef.getDocument { snapshot, error in
                        
                        defer {
                            dispatchGroup.leave()
                        }
                        
                        if let error = error {
                            self.delegate?.didFailWithError(error)
                            return
                        }
                        
                        guard let snapshot = snapshot else {
                            self.delegate?.didFailWithError(NSError(domain: "UserImageError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No snapshot found for User"]))
                            return
                        }
                        
                        let imageUrl = snapshot.get("imageUrl") as? String ?? ""
                        let name = snapshot.get("name") as? String ?? ""
                        let username = snapshot.get("username") as? String ?? "Unknown"
                        
                        
                        let entry = Entry(documentId: documentId,
                                          date: date.dateValue(),
                                          userName: username,
                                          userUsername: name,
                                          userText: userText,
                                          userImageUrl: imageUrl,
                                          timeAgo: differenceFromNow,
                                          isRepublished: isRepublished,
                                          isLiked: isLiked,
                                          likeCount: likeCount,
                                          commentCount: commentsCount,
                                          republishedCount: republishedCount)
                        data.append(entry)
                    }
                }
                
                
                dispatchGroup.notify(queue: .main) {
                    data.sort { $0.date > $1.date }
                    self.delegate?.didFetchData(data)
                }
            }

    }
    
    func likePost(postId: String, userId: String) {

        db.collection("Entries").document(postId).updateData([
            "likedBy": FieldValue.arrayUnion([userId])
        ]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Successfully liked post!")
            }
        }
    }
     
     func unlikePost(postId: String, userId: String) {

         db.collection("Entries").document(postId).updateData([
             "likedBy": FieldValue.arrayRemove([userId])
         ]) { error in
             if let error = error {
                 print("Error: \(error.localizedDescription)")
             } else {
                 print("Successfully unliked post!")
             }
         }
     }
    
    func fetchUser(forUserId userId: String, completion: @escaping (Result<(imageUrl: String, username: String), Error>) -> Void) {

            let docRef = db.collection("UserInfo").document(userId)
            
            docRef.getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = document, document.exists else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document not found"])))
                    return
                }
                
                // "imageUrl" alanını alıyoruz
                if let imageUrl = document.get("imageUrl") as? String {
                    if let username = document.get("username") as? String{
                        completion(.success((imageUrl: imageUrl, username: username)))
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "imageUrl not found"])))
                }
            }
        }
    
    func newPost(with entry:Entry, completion: @escaping (Bool,Error?) -> Void){
        let entriesCollection = db.collection("Entries")
        
        if let id = userUID {
            let data: [String: Any] = [
                "text": entry.userText,
                "likedBy": [],
                "date": Timestamp(date: Date()),
                "publisherUID": id
            ]
            entriesCollection.addDocument(data: data) { error in
                if let error = error{
                    completion(false,error)
                }else{
                    completion(true,nil)
                }
            }
        }
    }
    
    func editProfile(image: UIImage, username: String, name: String ,completion: @escaping (Bool,Error?) -> Void) {
        print("edit")
        let storageRef = Storage.storage().reference()
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(false, NSError(domain: "Image conversion failed", code: -1, userInfo: nil))
            return
        }
        
        let imageName = UUID().uuidString
        let imageRef = storageRef.child("media/\(imageName).jpeg")
        
        imageRef.putData(imageData) { metadata, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            imageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(false, error)
                    return
                }
                
                let db = Firestore.firestore()
                if let id = self.userUID {
                    db.collection("UserInfo").document(id).setData([
                        "imageUrl": downloadURL.absoluteString,
                        "username": username,
                        "name": name
                    ]) { error in
                        if let error = error {
                            completion(false, error)
                        } else {
                            completion(true, nil)
                        }
                    }
                }else{
                    completion(false,NSError(domain: "UserID not found", code: -1))
                    return
                }
            }
        }
    }
    
    func deleteEntry(documentId: String, completion: @escaping(Bool,Error?) -> Void){
        let entriesCollection = db.collection("Entries")
        
        let documentRef = entriesCollection.document(documentId)
        
        documentRef.delete { error in
            if let error = error{
                completion(false,error)
            }else{
                completion(true,nil)
            }
        }
    }
    
}

extension NetworkService {
    func differenceFromNow(timestamp: Date) -> String {
        let currentDate = Date()
        
        let differenceInSeconds = currentDate.timeIntervalSince(timestamp)
        let hours = differenceInSeconds / 3600
        
        // More than 24h
        if hours >= 24 {
            let days = Int(hours / 24)
            return "\(days)d"
        } else {
            return "\(Int(hours))h"
        }
    }
}

