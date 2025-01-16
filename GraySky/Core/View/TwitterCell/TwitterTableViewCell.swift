//
//  TwitterTableViewCell.swift
//  GraySky
//
//  Created by Umut Konmuş on 12.01.2025.
//

import UIKit

class TwitterTableViewCell: UITableViewCell {

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func moreClicked(_ sender: Any) {
    }
    @IBAction func shareClicked(_ sender: Any) {
    }
    @IBAction func likeClicked(_ sender: Any) {
    }
    @IBAction func retweetClicked(_ sender: Any) {
    }
    @IBAction func commentClicked(_ sender: Any) {
    }
}
