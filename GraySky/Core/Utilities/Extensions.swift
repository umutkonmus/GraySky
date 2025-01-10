//
//  Extensions.swift
//  GraySky
//
//  Created by Umut Konmuş on 8.01.2025.
//

import UIKit

extension UIViewController{
    func makeAlert(message:String){
        let alert = UIAlertController(title: "GraySky", message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

extension EntryCell {
    func configure(with entry: Entry) {
        self.documentId = entry.documentId
        usernameLabel.text = entry.userName
        userText.text = entry.userText
        //userImage.image = UIImage(named: entry.userImageUrl)
        userImage.sd_setImage(with: URL(string: entry.userImageUrl)!)
        //userImage.maskCircle()
        isLiked = entry.isLiked
        likeLabel.text = String(entry.likeCount)
        if entry.isLiked {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        }else {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        }
    }
}

extension UIImageView {
    public func maskCircle() {
        self.layer.cornerRadius = (self.frame.size.width) / 2
        self.clipsToBounds = true
        //self.layer.borderWidth = 3.0
        guard let backgroundColor = self.backgroundColor else { return }
        self.layer.borderColor = backgroundColor.cgColor
    }
}
