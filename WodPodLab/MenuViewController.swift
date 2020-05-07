//
//  MenuViewController.swift
//  WodPodLab
//
//  Created by Hugo Perez on 21/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dataSource: [String] = ["USERS", "MOVEMENTS", "PROGRAMS", "TRAINERS", "FINANCES", "STATS", "WODS", "INDEX MOVEMENTS"]
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.tableFooterView = UIView()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ADMIN"
        self.tableView.reloadData()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
        if StoredMovement.all().isEmpty {
            FireSession.shared.getAllMovements()
        }
        
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = dataSource[indexPath.row]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let searchUser = SearchUserViewController()
            self.navigationController?.pushViewController(searchUser, animated: true)
        } else if indexPath.row == 1 {
            let searchMotion = SearchMovementsTableViewController(mode: .EDIT)
            self.navigationController?.pushViewController(searchMotion, animated: true)
        } else if indexPath.row == 2 {
            let searchPrograms = SearchProgramsTableViewController()
            self.navigationController?.pushViewController(searchPrograms, animated: true)
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

}
