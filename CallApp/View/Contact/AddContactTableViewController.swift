//
//  AddContactTableViewController.swift
//  CallApp
//
//  Created by hau on 4/12/21.
//

import UIKit
import  FirebaseAuth

class AddContactTableViewController: UITableViewController {
    let searchController = UISearchController()
    private lazy var filteredContacts = [User]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    private lazy var recentAdded = [User]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.delegate = self
        searchController.searchResultsUpdater = self
    }
    override func viewDidAppear(_ animated: Bool) {
        searchController.searchSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "Icon-Small"), style: .done, target: nil, action: nil)
        navigationItem.searchController = searchController
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.filteredContacts.isEmpty {
            self.tableView.setEmptyData()
        }else{
            self.tableView.backgroundView = nil
        }
        return filteredContacts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddContactCell") as! AddContactTableViewCell
        cell.user = filteredContacts[indexPath.row]
        return cell
    }
   
}
extension AddContactTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let textSearch = searchController.searchBar.text else { return }
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startIndicatorActivity(viewController: self)
        FirestoreService.shared.fetchFilteredResults(with: textSearch) { (result) in
            switch result {
                case .success(let users):
                    self.filteredContacts = users
                    activityIndicator.stopAnimating()
                case .error(let error):
                    AlertServices.showAlert(self, title: "Error", message: error.localizedDescription)
                    activityIndicator.stopAnimating()
                    
            }
        }
    }
    func didPresentSearchController(_ searchController: UISearchController) {
            DispatchQueue.main.async {
                searchController.searchBar.becomeFirstResponder()
            }
    }
}

extension UISearchController {
    func searchSetup() {
        self.isActive = true
        self.hidesNavigationBarDuringPresentation = false
        self.searchBar.placeholder = "Email or Name..."
        self.obscuresBackgroundDuringPresentation = false
    }
}

