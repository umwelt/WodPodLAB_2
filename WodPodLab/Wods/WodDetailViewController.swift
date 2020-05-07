//
//  WodDetailViewController.swift
//  WodPodLab
//
//  Created by Hugo Perez on 27/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import UIKit
import SwiftyJSON
import Eureka

class WodDetailViewController: FormViewController, TypedRowControllerType {
    
    var wod: Wod!
    var index: Int = 1
    var programId: String!
    var programType: Int = 0
    
    var sets: [Sets] = []
    
    // protocol conformance
    public var row: RowOf<String>!
    public var onDismissCallback: ((UIViewController) -> Void)?
    
    
    init(wod: Wod, index: Int, programId: String, programType: Int = 0) {
        super.init(nibName: nil, bundle: nil)
        self.wod = wod
        self.index = index
        self.programId = programId
        self.programType = programType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wod.info.name = "DAY \(index)"
        self.wod.program = true
        self.wod.programId = self.programId
        self.title = self.wod.info.name
        
        
        switch programType {
        case 0:
            self.wod.wodType = "performance"
        case 1:
            self.wod.wodType = "interval"
        default:
            break
        }
        
        form +++
            Section("Wod Data")
            
            <<< TextRow() { row in
                row.title = "ID"
                if self.wod.id == "" {
                    self.wod.id = UUID().uuidString
                    self.wod.id = self.wod.id
                    row.value = self.wod.id
                } else {
                    row.value = self.wod.id
                }
                
                row.disabled = true
            }
            
            <<< TextRow() { row in
                row.title = "Name"
                row.value = wod.info.name
                row.disabled = true
            }
            
            
            /// Price per workout
            +++ Section("ROUNDS")
            <<< PickerRow<String>("ROUNDS") { (row : PickerRow<String>) -> Void in
                
                row.options = []
                for i in 1...100 {
                    row.options.append("\(i) ROUNDS")
                }
            }.onChange({ row in
                if let _value = row.value {
                    if let _numeric = _value.components(separatedBy: " ").first {
                        if let _intValue = Int(_numeric) {
                            self.wod.info.rounds = _intValue
                        }
                    }
                }
            })
            
            /// Price per workout
            +++ Section("FITNESS TEST MODE")
            <<< SwitchRow("isFitTest"){
                $0.title = "Fitness Test"
                $0.value = wod.info.isFitTest
            }.onChange({ row in
                self.wod.info.isFitTest = row.value ?? false
            })
        
        
        form +++
            
            
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                               header: "Add Movements",
                               footer: ".Insert adds a 'Add Item' (Add New Tag) button row as last cell.") { sec  in
                                
                                sec.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add a Movement"
                                    }
                                }
                                sec.tag = "movements_creator"
                                
                                sec.multivaluedRowToInsertAt = { index in
                                    
                                    return MovementPresenterRow() { row in
                                        
                                        row.title = "Mov Name"
                                        
                                        row.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                                            
                                            return SearchMovementsTableViewController(mode: .SEARCH, searchString: row.searchString, type: self.programType)
                                            }, onDismiss: { vc in
                                                
                                                if let _vc = vc as? SearchMovementsTableViewController {
                                                    
                                                    self.sets.append(_vc.activeSet)
                                                    row.activeSet = _vc.activeSet
                                                    
                                                    if let _displayName = _vc.selectedMovement.displayName {
                                                        row.searchString = _displayName
                                                        if _vc.activeSet.reps > 0 {
                                                            row.title = "\(_vc.activeSet.reps)x \(_displayName)"
                                                        } else {
                                                            row.title = "\(_vc.activeSet.interval)s \(_vc.activeSet.pause_length)p \(_displayName)"
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                _ = vc.navigationController?.popViewController(animated: true)
                                        })
                                    }
                                }
                                
                                /// Dynamic input
                                
                                self.wod.sets.enumerated().forEach { index, set in
                                    
                                    sec.append(MovementPresenterRow() { row in
                                        
                                        if let _stored = StoredMovement.byId(id: set.movementId) {
                                            row.title = _stored.displayName
                                        }
                                        
                                        row.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                                            return SearchMovementsTableViewController(mode: .SEARCH, searchString: row.searchString, type: self.programType)
                                            }, onDismiss: { vc in
                                                if let _vc = vc as? SearchMovementsTableViewController {
                                                    
                                                    self.sets.append(_vc.activeSet)
                                                    row.activeSet = _vc.activeSet
                                                    
                                                    if let _displayName = _vc.selectedMovement.displayName {
                                                        row.searchString = _displayName
                                                        row.title = "\(_vc.activeSet.reps)x \(_displayName)"
                                                    }
                                                    
                                                    
                                                }
                                                _ = vc.navigationController?.popViewController(animated: true)
                                        })
                                        }
                                        
                                        
                                    )
                                }
                                
                                
        }
        
        form +++
            Section()
            <<< ButtonRow(){
                $0.title = "ADD \(self.wod.info.name)"
                
            }.onCellSelection({ (cell, row) in
                
                self.wod.sets.removeAll()
                self.wod.sets.append(contentsOf: self.sets)
                self.wod.intentedProgram = self.programId
                self.wod.programId = self.programId
                self.wod.program = true
                self.onDismissCallback!(self)
            })
        // Do any additional setup after loading the view.
    }
    
    
    
    
}
