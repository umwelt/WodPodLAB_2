//
//  SearchMovementsTableViewController.swift
//  WodPodLab
//
//  Created by Hugo Perez on 23/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import UIKit
import PromiseKit
import Eureka
import SwiftyJSON
import SDCAlertView
import NumberPicker

enum MODE {
    case SEARCH
    case EDIT
}

class SearchMovementsTableViewController: UITableViewController, TypedRowControllerType, NumberPickerDelegate {
    
    var mode: MODE = .EDIT
    
    // protocol conformance
    public var row: RowOf<String>!
    public var onDismissCallback: ((UIViewController) -> Void)?
    
    var allMovements: [Movement] = []
    var selectedMovement: Movement = Movement(from: JSON.null)
    var activeSet: Sets!
    var searchString: String = ""
    
    var searchController: UISearchController!
    
    private var resultsTableController: MovementsResultsTableViewController!
    
    var programType: Int =  0
    
    /// 0 Performance
    /// 1 Interval
    init(mode: MODE, searchString: String = "", type: Int = 0) {
        super.init(nibName: nil, bundle: nil)
        self.mode = mode
        self.searchString = searchString
        self.programType = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activeSet = Sets(JSON.null)
        
        self.title = "Movs Search"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        resultsTableController = MovementsResultsTableViewController()
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
        
        
        if !searchString.isEmpty {
            self.searchController.searchBar.text = searchString
            self.searchForString(searchText: searchString, force: true)
        }
        
    }
    
    @objc
    func addTapped() {
        let movDetail = MovementDetailViewController(mov: Movement(from: JSON.null))
        self.navigationController?.pushViewController(movDetail, animated: true)
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
        
        self.searchController.searchBar.endEditing(true)
        
        switch mode {
        case .EDIT:
            let selectedMov: Movement!
            
            // Check to see which table view cell was selected.
            if tableView === self.tableView {
                selectedMov = allMovements[indexPath.row]
            } else {
                selectedMov = resultsTableController.allMovements[indexPath.row]
            }
            
            // Set up the detail view controller to push.
            let detailViewController = MovementDetailViewController(mov: selectedMov)
            navigationController?.pushViewController(detailViewController, animated: true)
        case .SEARCH:
            
            // Check to see which table view cell was selected.
            if tableView === self.tableView {
                self.selectedMovement = allMovements[indexPath.row]
            } else {
                self.selectedMovement = resultsTableController.allMovements[indexPath.row]
            }
            
            self.openNumberPicker()
            
            
            
        }
        //
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func openNumberPicker() {
        
        let numberPicker = NumberPicker(delegate: self, maxNumber: 100) // set max number
        
        numberPicker.tintColor = .white
        
        switch programType {
        case 0:
            numberPicker.heading = "REPS"
            numberPicker.bgGradients = [.blue, .black]
            numberPicker.defaultSelectedNumber = 10 // set default selected number
        case 1:
            
            if self.activeSet.interval > 0 {
                numberPicker.heading = "PAUSE IN SECS"
                
            } else {
                numberPicker.heading = "SECS"
            }
            
            numberPicker.bgGradients = [.blue, .black]
            numberPicker.defaultSelectedNumber = 30 // set default selected number
        default:
            break
        }
        
        
        

        self.searchController.present(numberPicker, animated: true, completion: nil)
    }
    
    func selectedNumber(_ number: Int) {
        
        switch programType {
        case 0:
            
            self.activeSet.id = "\(UUID().uuidString)_\(self.selectedMovement.id ?? "")"
            self.activeSet.reps = number
            self.activeSet.movementId = self.selectedMovement.id ?? ""
            self.onDismissCallback!(self)
        case 1:
            
            
            self.activeSet.id = "\(UUID().uuidString)_\(self.selectedMovement.id ?? "")"            
            self.activeSet.movementId = self.selectedMovement.id ?? ""
            
            
            if self.activeSet.interval > 0 {
                self.activeSet.pause_length = number
                self.onDismissCallback!(self)
            } else {
                self.activeSet.interval = number
                self.openNumberPicker()
            }
            
            
            
        default:
            break
        }
        
        
        
        
        
        
        
        
//
    }
    
}


extension SearchMovementsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let _searchText =  searchBar.text {
            self.searchForString(searchText: _searchText)
        }
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchForString(searchText: searchText)
    }
    
    fileprivate func searchForString(searchText: String, force: Bool = false) {
        firstly {
            SearchSession.shared.movesSearch(with: searchText)
        }.map { (data)  in
            self.allMovements.removeAll()
            self.allMovements = data
            if force {
                self.updateSearchResults(for: self.searchController)
                DispatchQueue.main.async {
                    self.searchController.isActive = true
                    self.searchController.searchBar.becomeFirstResponder()
                }
            }
        }.catch { (error) in
            AlertController.alert(withTitle: "ERROR", message: error.localizedDescription, actionTitle: "OK", customView: nil)
        }
    }
    
}


extension SearchMovementsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Apply the filtered results to the search results table.
        if let resultsController = searchController.searchResultsController as? MovementsResultsTableViewController {
            resultsController.allMovements = self.allMovements
            resultsController.tableView.reloadData()
        }
    }
}



// MARK: - UISearchControllerDelegate

// Use these delegate functions for additional control over the search controller.

extension SearchMovementsTableViewController: UISearchControllerDelegate {
    
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
