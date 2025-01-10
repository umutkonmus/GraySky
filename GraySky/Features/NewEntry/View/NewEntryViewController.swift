//
//  NewEntryViewController.swift
//  GraySky
//
//  Created by Umut Konmuş on 30.12.2024.
//

import UIKit
import FirebaseAuth

class NewEntryViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    
    let service = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.userUID = Auth.auth().currentUser?.uid
        textView.delegate = self
        textView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        countLabel.text = "\(count)/50"
        
        if count > 46 {
            countLabel.textColor = .systemRed
        }else{
            countLabel.textColor = .link
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 50;
    }
    
    @IBAction func publishClicked(_ sender: Any) {
        // API CALL
        let entry = Entry(documentId: UUID().uuidString, date:Date(), userName: service.username!, userText: textView.text, userImageUrl: service.userImageUrl!, isLiked: false, likeCount: 0)
        service.newPost(with: entry) { success, error in
            if success{
                self.dismiss(animated: true)
            }
        }
    }
}
