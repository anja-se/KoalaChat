//
//  ContactCell.swift
//  KoalaChat
//
//  Created by Anja Seidel on 11.05.23.
//

import UIKit

class ContactCell: UITableViewCell {
    
    static let identifier = "ContactCell"

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
    
    func configure(name: String, isAddable: Bool = false) {
        nameLabel.text = name
        addButton.isHidden = !isAddable
        if isAddable {
            accessoryType = .none
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
    }
    
    
}
