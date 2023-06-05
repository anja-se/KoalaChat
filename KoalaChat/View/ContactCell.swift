//
//  ContactCell.swift
//  KoalaChat
//
//  Created by Anja Seidel on 11.05.23.
//

import UIKit

class ContactCell: UITableViewCell {
    
    static let identifier = "ContactCell"
    var contact: Contact?

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = imgView.frame.height/2
        //imgView.image = UIImage(named: "KoalaImage")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(user: Contact, isAddable: Bool = false) {
        self.contact = user
        nameLabel.text = user.name
        addButton.isHidden = !isAddable
        if isAddable {
            accessoryType = .none
        }
        if let image = user.image {
            self.imgView.image = image
        } else {
            self.imgView.image = UIImage(named: "KoalaImage")
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        guard let contact else { return }
        AppDelegate.user!.addContact(contact)
    }
    
    
}
