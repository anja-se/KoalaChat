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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(text: String, sender: Bool){
        label.text = text
        if sender {
            messageBubble.rightAnchor.constraint(equalTo: messageBubble.superview!.rightAnchor).isActive = true
            messageBubble.leftAnchor.constraint(greaterThanOrEqualTo: messageBubble.superview!.leftAnchor, constant: 32).isActive = true
        } else {
            messageBubble.leftAnchor.constraint(equalTo: messageBubble.superview!.leftAnchor).isActive = true
            messageBubble.rightAnchor.constraint(lessThanOrEqualTo: messageBubble.superview!.rightAnchor, constant: -32).isActive = true
            messageBubble.backgroundColor = UIColor.white
        }
    }
    
}
