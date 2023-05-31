//
//  ContactCell.swift
//  KoalaChat
//
//  Created by Anja Seidel on 11.05.23.
//

import UIKit

class ContactCell: UITableViewCell {
    
    static let identifier = "ContactCell"
    var user: Contact?

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = imgView.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(user: Contact, isAddable: Bool = false) {
        self.user = user
        nameLabel.text = user.name
        addButton.isHidden = !isAddable
        if isAddable {
            accessoryType = .none
        }
        if let url = user.imageURL {
            ImageStorage().downloadImage(from: url, completion: { img in
                if let img {
                    self.imgView.image = img
                }
            })
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        guard let user else { return }
        AppDelegate.user!.addContact(user)
    }
    
    
}
