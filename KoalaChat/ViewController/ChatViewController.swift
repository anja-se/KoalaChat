//
//  ChatViewController.swift
//  KoalaChat
//
//  Created by Anja Seidel on 06.03.23.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MessageCell.identifier, bundle: nil), forCellReuseIdentifier: MessageCell.identifier)
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try authService.signOut()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as! MessageCell
        let array = [true, false, true, false, false]
        let someText = ["Hi", "Hi there", "What's up?", "Not much... just doing some programming, working on that new chat app.", "How are things for you?"]
        cell.configure(text: someText[indexPath.row], sender: array[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

}
