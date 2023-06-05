//
//  ContactsViewController.swift
//  KoalaChat
//
//  Created by Anja Seidel on 11.05.23.
//

import UIKit

class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pictureButton: UIBarButtonItem!
    var chats = AppDelegate.user!.chatRepo!.chats.sorted()
    var chatIndex = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ContactCell.identifier, bundle: nil), forCellReuseIdentifier: ContactCell.identifier)
        navigationItem.hidesBackButton = true
        self.title = "Chats"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.user?.chatRepo?.contactDelegate = self
        chats = AppDelegate.user!.chatRepo!.chats.sorted()
        tableView.reloadData()
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try AppDelegate.authService.signOut()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.chatSegue {
            let vc = segue.destination as! ChatViewController
            vc.chat = chats[chatIndex]
        }
    }
    
    //MARK: TableViewDelegate Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as! ContactCell
        cell.configure(user: chats[indexPath.row].contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatIndex = indexPath.row
        self.performSegue(withIdentifier: K.chatSegue, sender: self)
    }
}

//MARK: Contact Delegate Method
extension ChatListViewController: ContactDelegate {
    func update(){
        chats = AppDelegate.user!.chatRepo!.chats.sorted()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


