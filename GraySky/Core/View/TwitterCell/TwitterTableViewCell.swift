//
//  TwitterTableViewCell.swift
//  GraySky
//
//  Created by Umut Konmuş on 12.01.2025.
//

import UIKit

class TwitterTableViewCell: UITableViewCell {

    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var republishButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var emptyView1: UIView!
    @IBOutlet weak var emptyView2: UIView!
    @IBOutlet weak var emptyView3: UIView!
    @IBOutlet weak var entryText: UILabel!
    
    var documentId : String?
    var isLiked = false
    let service = NetworkService()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func moreClicked(_ sender: Any) {
        guard let viewController = findViewController() else {return}
        
        if let vc = viewController as? ProfileViewController {
            vc.showOptionsMenu(documentId:documentId ?? "")
        }
    }
    
    
    @IBAction func likeClicked(_ sender: Any) {
        if isLiked {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            isLiked = false
            likeCountLabel.text = String(Int(likeCountLabel.text!)! - 1)
            // API call
            if let id = documentId{
                service.unlikePost(postId: id, userId: service.userUID ?? "")
            }
        }else{
            isLiked = true
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeCountLabel.text = String(Int(likeCountLabel.text!)! + 1)
            // API call
            
            if let id = documentId{
                service.likePost(postId: id, userId: service.userUID ?? "")
            }
        }
    }
    
    @IBAction func retweetClicked(_ sender: Any) {
    }
    @IBAction func commentClicked(_ sender: Any) {
    }
    
    @IBAction func shareClicked(_ sender: Any) {
    }
}
