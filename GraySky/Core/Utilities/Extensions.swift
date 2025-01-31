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
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderWidth = 4
        self.layer.borderColor = getBorderColor().cgColor
        self.clipsToBounds = true
    }
    func getBorderColor() -> UIColor {
        return UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? .black : .white
            }
    }
}

extension UITableViewCell {
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
}

extension UIColor {
    /// Creates UIColor from hex
    /// - Parameters:
    ///   - hex: Hexadecimal color code (örn. 0x4C9EEB veya "4C9EEB")
    ///   - alpha: Opacity value for color (0.0 - 1.0)
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
