//
//  MessageCell.swift
//  KoalaChat
//
//  Created by Anja Seidel on 11.05.23.
//

import UIKit

class MessageCell: UITableViewCell {
    
    static let identifier = "MessageCell"
    

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    
    var contactLeft: NSLayoutConstraint?
    var contactRight: NSLayoutConstraint?
    var senderLeft: NSLayoutConstraint?
    var senderRight: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
         contactLeft = messageBubble.leftAnchor.constraint(equalTo: messageBubble.superview!.leftAnchor)
         contactRight = messageBubble.rightAnchor.constraint(lessThanOrEqualTo: messageBubble.superview!.rightAnchor, constant: -32)
         senderLeft = messageBubble.leftAnchor.constraint(greaterThanOrEqualTo: messageBubble.superview!.leftAnchor, constant: 32)
         senderRight = messageBubble.rightAnchor.constraint(equalTo: messageBubble.superview!.rightAnchor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(text: String, sender: Bool){
        label.text = text
        if sender {
            messageBubble.backgroundColor = UIColor(named: "Bubble1")
            contactLeft?.isActive = false
            contactRight?.isActive = false
            senderLeft?.isActive = true
            senderRight?.isActive = true
        } else {
            messageBubble.backgroundColor = UIColor(named: "Bubble2")
            senderLeft?.isActive = false
            senderRight?.isActive = false
            contactLeft?.isActive = true
            contactRight?.isActive = true
        }
        
    }
    
}
