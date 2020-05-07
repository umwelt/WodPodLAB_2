//
//  SearchProgramsTableViewController.swift
//  WodPodLab
//
//  Created by Hugo Perez on 24/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import UIKit
import SwiftyJSON
import PromiseKit
import SDCAlertView

class SearchProgramsTableViewController: UITableViewController {
    
    var allPrograms: [Program] = []
    
    var searchController: UISearchController!
    
    private var resultsTableController: ProgramsResultsTableViewController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Programs Search"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "subtitleCell")
        resultsTableController = ProgramsResultsTableViewController()
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
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        /** Search presents a view controller by applying normal view controller presentation semantics.
         This means that the presentation moves up the view controller hierarchy until it finds the root
         view controller or one that defines a presentation context.
         */
        
        /** Specify that this view controller determines how the search controller is presented.
         The search controller should be presented modally and match the physical size of this view controller.
         */
        definesPresentationContext = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .done, target: self, action: #selector(addTapped))
              
        
    }
    
    @objc
    fileprivate func addTapped() {
        let detailViewController = ProgramDetailViewController(program: Program(JSON.null))
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let selectedProgram: Program!
        
        // Check to see which table view cell was selected.
        if tableView === self.tableView {
            selectedProgram = allPrograms[indexPath.row]
        } else {
            selectedProgram = resultsTableController.allPrograms[indexPath.row]
        }
        
        // Set up the detail view controller to push.
        let detailViewController = ProgramDetailViewController(program: selectedProgram)
        navigationController?.pushViewController(detailViewController, animated: true)

        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    
    
    
}


extension SearchProgramsTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           
           firstly {
               SearchSession.shared.programSearch(with: searchBar.text!)
           }.map { (data)  in
               self.allPrograms.removeAll()
               self.allPrograms = data
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
               SearchSession.shared.programSearch(with: searchText)
           }.map { (data)  in
               self.allPrograms.removeAll()
               self.allPrograms = data
           }.catch { (error) in
               AlertController.alert(withTitle: "ERROR", message: error.localizedDescription, actionTitle: "OK", customView: nil)
           }
       }
    
}


extension SearchProgramsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Apply the filtered results to the search results table.
        if let resultsController = searchController.searchResultsController as? ProgramsResultsTableViewController {
            resultsController.allPrograms = self.allPrograms
            resultsController.tableView.reloadData()
        }
    }
}


// MARK: - UISearchControllerDelegate

// Use these delegate functions for additional control over the search controller.

extension SearchProgramsTableViewController: UISearchControllerDelegate {
    
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
