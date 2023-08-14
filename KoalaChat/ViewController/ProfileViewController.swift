//
//  ProfileViewController.swift
//  KoalaChat
//
//  Created by Anja Seidel on 31.05.23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let image = AppDelegate.user?.image {
            imageView.image = image
        }
    }
    
    func configure(){
        title = AppDelegate.user!.name
        let radius = imageView.frame.height / 2
        imageView.layer.cornerRadius = radius
        imageView.layer.borderColor = UIColor.systemGray5.cgColor
        imageView.layer.borderWidth = 2
        imageButton.layer.cornerRadius = radius
    }
    
    @IBAction func selectImageButtonClicked(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
    }
    
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Get the selected image from the info dictionary
        if let selectedImage = info[.originalImage] as? UIImage {
            //upload
            ImageStorage().uloadImage(selectedImage)
            
            //display
            imageView.image = selectedImage
        }
        
        // Dismiss the image picker
        picker.dismiss(animated: true, completion: nil)
    }
}
