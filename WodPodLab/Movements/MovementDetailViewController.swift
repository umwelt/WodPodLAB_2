//
//  MovementDetailViewController.swift
//  WodPodLab
//
//  Created by Hugo Perez on 23/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import UIKit
import PromiseKit
import Eureka
import SDCAlertView

class MovementDetailViewController: FormViewController {
    

    
    var update: Bool = true

    
    var mov: Movement! {
        didSet {
            self.title = mov.displayName
        }
    }
    
    
    init(mov: Movement) {
        super.init(nibName: nil, bundle: nil)
        self.mov = mov
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = mov.displayName
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "DELETE", style: .plain, target: self, action: #selector(removeTapped))
        
        form +++ Section("Movement Detail")
            
            <<< TextRow() { row in
                row.title = "ID"
                row.value = mov.id
                row.disabled = true
                
            }
            
            
            <<< TextRow() { row in
                row.title = "Display Name"
                row.placeholder = "Movement Name"
                row.value = mov.displayName
                
            }.onChange({ (row) in
                self.mov.displayName = row.value
            })
            
            <<< TextRow() { row in
                row.title = "Equipment"
                row.placeholder = "Equipment Name"
                row.value = mov.equipment
                
            }.onChange({ row in
                self.mov.equipment = row.value
            })
            
            <<< TextRow() { row in
                row.title = "MET"
                row.placeholder = "8.0"
                row.value = mov.met
                
            }.onChange({ row in
                self.mov.met = row.value
            })
            
            <<< TextRow() { row in
                row.title = "Video URL"
                row.placeholder = "..."
                row.value = mov.videoUrl
                
            }.onChange({ row in
                self.mov.videoUrl = row.value
            })
        
        form +++ Section("Movement modifiers")
            
            <<< SwitchRow("distance"){
                $0.title = "Distance"
                $0.value = mov.distance?.boolValue
            }.onChange({ row in
                self.mov.distance = String(row.value ?? false)
            })
            
            <<< SwitchRow("double_weight"){
                $0.title = "Double Weight"
                $0.value = mov.doubleWeight?.boolValue
            }.onChange({ row in
                self.mov.doubleWeight = String(row.value ?? false)
            })
            
            <<< SwitchRow("reps"){
                $0.title = "Reps"
                $0.value = mov.reps?.boolValue
            }.onChange({ row in
                self.mov.reps = String(row.value ?? false)
            })
            
            <<< SwitchRow("adv"){
                $0.title = "Advanced"
                $0.value = mov.adv?.boolValue
            }.onChange({ row in
                self.mov.adv = String(row.value ?? false)
            })
            
            <<< SwitchRow("cardio"){
                $0.title = "Cardio"
                $0.value = mov.cardio?.boolValue
            }.onChange({ row in
                self.mov.cardio = String(row.value ?? false)
            })
            
            <<< SwitchRow("double_sided"){
                $0.title = "Double Sided"
                $0.value = mov.doubleSided?.boolValue
            }.onChange({ row in
                self.mov.doubleSided = String(row.value ?? false)
            })
            
            <<< SwitchRow("time"){
                $0.title = "Time"
                $0.value = mov.time?.boolValue
            }.onChange({ row in
                self.mov.time = String(row.value ?? false)
            })
            
            <<< SwitchRow("weight"){
                $0.title = "Weight"
                $0.value = mov.weight?.boolValue
            }.onChange({ row in
                self.mov.weight = String(row.value ?? false)
            })
        
        form +++ SelectableSection<ListCheckRow<String>>("Primary Muscles", selectionType: .multipleSelection)
        
        let muscles_bank = ["Calves", "Biceps", "Forearms", "Quads", "Delts", "Triceps", "Gluteus", "Adductors", "Lowerback", "Middleback", "Traps", "Hamstrings", "Chest", "Abs", "Lats"].sorted()
        for option in muscles_bank {
            form.last! <<< ListCheckRow<String>(option){ listRow in
                listRow.tag = option + "primary"
                listRow.title = option
                listRow.selectableValue = option
                if (mov.primaryMuscles?.contains(option))! {
                    listRow.value = option
                }
            }.onChange({ row in
                
                var stringSet: Set<String> = Set()
                self.mov.primaryMuscles?.forEach({ (muscle) in
                    stringSet.insert(muscle)
                })
                if let _value = row.value {
                    stringSet.insert(_value)
                } else {
                    if let _selectable = row.selectableValue {
                        stringSet.remove(_selectable)
                    }
                }
                self.mov.primaryMuscles = Array(stringSet)
            })
        }
        
        form +++ SelectableSection<ListCheckRow<String>>("Secondary Muscles", selectionType: .multipleSelection)
        
        
        for option in muscles_bank {
            form.last! <<< ListCheckRow<String>(option){ listRow in
                listRow.tag = option + "secondary"
                listRow.title = option
                listRow.selectableValue = option
                if (mov.secondaryMuscles?.contains(option))! {
                    listRow.value = option
                }
            }.onChange({ row in
                var stringSet: Set<String> = Set()
                self.mov.secondaryMuscles?.forEach({ (muscle) in
                    stringSet.insert(muscle)
                })
                if let _value = row.value {
                    stringSet.insert(_value)
                } else {
                    if let _selectable = row.selectableValue {
                        stringSet.remove(_selectable)
                    }
                }
                self.mov.secondaryMuscles = Array(stringSet)
            })
        }
        
        form +++
            Section()
            <<< ButtonRow(){
                $0.title = "Save Movement"
                
            }.onCellSelection({ (cell, row) in
                
                if self.mov.id == "" {
                    self.update = false
                    self.mov.id = UUID().uuidString
                    self.mov.objectID = self.mov.id
                }
                
                firstly  {
                    
                    FireSession.shared.mov_update(self.mov, update: self.update)
                }.catch { (error) in
                    Messages.shared.showError(error.localizedDescription)
                }.finally {
                    self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                    Messages.shared.showCompleted()
                }
            })
        
        
        
    }
    
    @objc
    fileprivate func removeTapped() {
        
        let alert = AlertController(title: "IMPORTANT", message: "Deletion is permanent!")
        
        let actionOk = AlertAction(title: "DELETE", style: .destructive) { action in
            
            firstly {
                FireSession.shared.mov_remove(self.mov)
            }.catch { (error) in
                Messages.shared.showError(error.localizedDescription)
            }.finally {
                Messages.shared.showCompleted()
                self.navigationController?.popViewController(animated: true)
            }
            
            
        }
        
        
        let cancelAction = AlertAction(title: "CANCEL", style: .normal) { action in
            print("cancel action")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(actionOk)
        
        alert.present()
                
    }

    
}
