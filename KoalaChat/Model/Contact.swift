//
//  Contact.swift
//  KoalaChat
//
//  Created by Anja Seidel on 15.05.23.
//

import Foundation
import UIKit

class Contact: Codable {
    let id: String
    var name: String
    var imageURL: String?
    var image: UIImage?
    
    init(id: String, name: String, imageURL: String? = nil) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
    }
    
    enum CodingKeys: CodingKey {
        case id, name, imageURL
    }
}

protocol ContactDelegate {
    func update()
}
