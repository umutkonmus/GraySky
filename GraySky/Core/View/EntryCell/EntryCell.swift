//
//  EntryCell.swift
//  GraySky
//
//  Created by Umut Konmuş on 30.12.2024.
//

import UIKit
import FirebaseAuth
import SDWebImage

class EntryCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userText: UILabel!
    
    let userUID = Auth.auth().currentUser?.uid ?? ""
    var documentId : String?
    var isLiked = false
    let service = NetworkService()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        service.userUID = userUID
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func optionsClicked(_ sender: Any) {
        guard let viewController = findViewController() else {return}
        
        if let vc = viewController as? ProfileViewController {
            vc.showOptionsMenu(documentId:documentId ?? "")
        }
    }
    
    func findViewController() -> UIViewController? {
            var responder: UIResponder? = self
            while responder != nil {
                responder = responder?.next
                if let viewController = responder as? UIViewController {
                    return viewController
                }
            }
            return nil
        }
    
    @IBAction func likeClicked(_ sender: Any) {
        if isLiked {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            isLiked = false
            likeLabel.text = String(Int(likeLabel.text!)! - 1)
            // API call
            if let id = documentId{
                service.unlikePost(postId: id, userId: userUID)
            }
        }else{
            isLiked = true
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            likeLabel.text = String(Int(likeLabel.text!)! + 1)
            // API call
            
            if let id = documentId{
                service.likePost(postId: id, userId: userUID)
            }
        }
        
    }
}
