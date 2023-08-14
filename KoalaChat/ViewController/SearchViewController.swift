//
//  SearchViewController.swift
//  KoalaChat
//
//  Created by Anja Seidel on 11.05.23.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var allUser: [Contact] = []
    var displayUser: [Contact] = []
    var searchText: String? {
        searchTextField.text
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Chat"
        self.hideKeyboardWhenTappedAround()
        tableView.dataSource = self
        tableView.register(UINib(nibName: ContactCell.identifier, bundle: nil), forCellReuseIdentifier: ContactCell.identifier)
        searchView.layer.cornerRadius = 5
        tableView.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.user?.chatRepo?.contactDelegate = self
        Task {
            do {
                allUser = try await AppDelegate.user!.chatRepo!.getAllUser()
                displayUser = allUser
                tableView.reloadData()
            } catch {
                print("There was an error loading user data: \(error)")
            }
        }
    }
    
    //MARK: - TableView data source methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as! ContactCell
        cell.configure(user: displayUser[indexPath.row], isAddable: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayUser.count
    }
    
    //MARK: - TextField methods
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if let searchText {
            if !searchText.isEmpty {
                displayUser = allUser.filter {
                    $0.name.lowercased().contains(searchText.lowercased())
                }
            } else {
                displayUser = allUser
            }
        }
        tableView.reloadData()
    }
}


//MARK: - ContactDelegate methods
extension SearchViewController: ContactDelegate {
    func update() {
        Task {
            do {
                allUser = try await AppDelegate.user!.chatRepo!.getAllUser()
                displayUser = allUser
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.searchTextField.text = ""
                    self.searchTextField.endEditing(true)
                }
            } catch {
                print("There was an error loading user data: \(error)")
            }
        }
    }
}
