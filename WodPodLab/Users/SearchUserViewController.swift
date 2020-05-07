//
//  SearchUserViewController.swift
//  WodPodLab
//
//  Created by Hugo Perez on 22/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import UIKit
import PromiseKit
import SDCAlertView

class SearchUserViewController: UITableViewController {
    
    var allUsers: [User] = []
    
    /// Search controller to help us with filtering items in the table view.
    var searchController: UISearchController!
    
    /// Search results table view.
    private var resultsTableController: ResultsTableController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "User Search"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        resultsTableController = ResultsTableController()
        
        resultsTableController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        
        //searchController.searchBar.scopeButtonTitles = ["email", "username"]
        
        // Place the search bar in the navigation bar.
        navigationItem.searchController = searchController
        
        // Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        /** Search presents a view controller by applying normal view controller presentation semantics.
         This means that the presentation moves up the view controller hierarchy until it finds the root
         view controller or one that defines a presentation context.
         */
        
        /** Specify that this view controller determines how the search controller is presented.
         The search controller should be presented modally and match the physical size of this view controller.
         */
        definesPresentationContext = true
        
        tableView.tableFooterView = UIView()
        
        //        setupDataSource()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let selectedUser: User!
        
        // Check to see which table view cell was selected.
        if tableView === self.tableView {
            selectedUser = allUsers[indexPath.row]
        } else {
            selectedUser = resultsTableController.allUsers[indexPath.row]
        }
        
        // Set up the detail view controller to push.
        let detailViewController = UserDetailViewController(user: selectedUser)
        navigationController?.pushViewController(detailViewController, animated: true)

        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
   
    
}

// MARK: - UISearchBarDelegate

extension SearchUserViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        firstly {
            SearchSession.shared.userSearch(with: searchBar.text!)
        }.map { (data)  in
            self.allUsers.removeAll()
            self.allUsers = data
            searchBar.resignFirstResponder()
        }.catch { (error) in
            AlertController.alert(withTitle: "ERROR", message: error.localizedDescription, actionTitle: "OK", customView: nil)
        }
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        firstly {
            SearchSession.shared.userSearch(with: searchText)
        }.map { (data)  in
            self.allUsers.removeAll()
            self.allUsers = data
        }.catch { (error) in
            AlertController.alert(withTitle: "ERROR", message: error.localizedDescription, actionTitle: "OK", customView: nil)
        }
    }
    
}

extension SearchUserViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Apply the filtered results to the search results table.
        if let resultsController = searchController.searchResultsController as? ResultsTableController {
            resultsController.allUsers = self.allUsers
            resultsController.tableView.reloadData()
        }
    }
    
}

// MARK: - UISearchControllerDelegate

// Use these delegate functions for additional control over the search controller.

extension SearchUserViewController: UISearchControllerDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
}
