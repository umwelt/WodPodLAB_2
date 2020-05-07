//
//  ProgramDetailViewController.swift
//  WodPodLab
//
//  Created by Hugo Perez on 24/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import UIKit
import PromiseKit
import Eureka
import SwiftyJSON
import ImageRow
import FirebaseStorage
import MaterialActivityIndicator


class ProgramDetailViewController: FormViewController {
    
    var program: Program!
    var programType: Int = 0
    
    let storage: Storage = Storage.storage(url: "gs://wodpod-3b99b.appspot.com")
    
    
    init(program: Program) {
        super.init(nibName: nil, bundle: nil)
        self.program = program
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if self.program.id!.isEmpty {
            self.program.id = UUID().uuidString
            self.program.objectID = self.program.id
            self.title = "Program Name"
            self.program.author.name = Program.AUTHORS.WODPOD_LAB
            self.setLayout()
        } else {
            self.getProgram()
            self.title = program.name
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "DELETE", style: .plain, target: self, action: #selector(removeTapped))
        }
        
    }
    
    
    fileprivate func getProgram() {
        
        firstly {
            FireSession.shared.getProgramData(for: self.program.id)
        }.compactMap { program in
            self.program = program
            self.setLayout()
        }.catch { (error) in
            Messages.shared.showError(error.localizedDescription)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    fileprivate func setLayout() {
        form +++ Section("PROGRAM FEATURES")
            
            
            // MARK: - TYPE
            +++ Section("PROGRAM TYPE")
            <<< ActionSheetRow<String>() { row in
                row.title = "SELECT TYPE"
                row.selectorTitle = "TYPE"
                row.options = [Program._modeType.PERFORMANCE,
                               Program._modeType.INTERVAL]
                row.add(rule: RuleRequired())

            }.onChange({ row in
                row.title = "SELECTED  --->"
                row.reload()
                if let _value = row.value {
                    self.program.type = _value
                    if _value == Program._modeType.PERFORMANCE {
                        self.programType = 0
                    } else {
                        self.programType = 1
                    }
                }
            })
            
            
            // MARK: - METADATA SECTION
            +++ Section("METADATA")
            
            <<< TextRow() { row in
                row.title = "ID"
                row.value = program.id
                row.disabled = true
                row.add(rule: RuleRequired())
            }
            
            <<< TextRow() { row in
                row.title = "Name"
                row.value = program.name
                row.add(rule: RuleRequired())
            }.onChange({ row in
                
                if let _value = row.value {
                    self.program.name = _value.trimmingCharacters(in: .whitespacesAndNewlines)
                    self.title = self.program.name
                    print("Program Name: \(self.program.name)")
                }
            })
            
            
            // MARK: - HEADLINE
            +++ Section("HEADLINE")
            
            <<< TextAreaRow() { row in
                row.value = program.tagLine
                row.placeholder = "Hit the imagination of your clients with the fewest words possible. Tell them what this plan is about"
                row.add(rule: RuleRequired())
            }.onChange({ row in
                if let _value = row.value {
                    self.program.tagLine = _value.htmlConverted
                }
            })
            
            
            // MARK: - DIFFICULTY
            +++ Section("TRAINING DIFFICULTY")
            <<< ActionSheetRow<String>() { row in
                row.title = "DIFFICULTY"
                row.selectorTitle = "DIFFICULTY"
                row.options = ["BEGINNER", "INTERMEDIATE", "ADVANCED"]
                row.value = "BEGINNER"
            }.onChange({ row in
                row.title = "SELECTED  --->"
                if let _value = row.value {
                    self.program.difficulty = _value
                }
            })
            
            
            // MARK: - MAIN FITNESS GOALS
            +++ Section("MAIN FITNESS GOALS")
            
            <<< ActionSheetRow<String>() { row in
                row.title = "MAIN"
                row.selectorTitle = "GOALS"
                row.options = Program.fitnessGoals()
                row.value = "Select One"
            }.onChange({ row in
                
                if let _value = row.value {
                    self.program.main_goals = _value
                    row.title = "SELECTED  --->"
                }
            })
            
            // MARK: - SECONDARY FITNESS GOALS
            +++ Section("SECONDARY FITNESS GOALS")
            <<< ActionSheetRow<String>() { row in
                row.title = "SECONDARY"
                row.selectorTitle = "GOALS"
                row.options = Program.fitnessGoals()
                row.value = "Select One"
            }.onChange({ row in
                if let _value = row.value {
                    self.program.secondary_goals = _value
                    row.title = "SELECTED  --->"
                }
            })
            
            // MARK: - DESCRIPTION
            +++ Section("DESCRIPTION")
            <<< TextAreaRow() { row in
                row.title = "Description"
                row.value = program.pDescription
                row.placeholder = "Program Description"
                row.add(rule: RuleRequired())
            }.onChange({ row in
                if let _value = row.value {
                    self.program.pDescription = _value.htmlConverted
                    print(self.program.pDescription)
                }
            })
            
            // MARK: - Recommendeed training days
            +++ Section("RECOMMENDED TRAINING DAYS OR FREQUENCY")
            <<< MultipleSelectorRow<String>() {
                $0.title = "Days"
                $0.options = ["ALL", "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
                $0.value = []
            }
            .onPresent { from, to in
                to.title = "TRAINING DAYS"
                to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(ProgramDetailViewController.multipleSelectorDone(_:)))
            }.onChange({ row in
                if let _values = row.value {
                    self.program.t_days.removeAll()
                    self.program.t_days.append(contentsOf: Array(_values))
                    print(self.program.t_days)
                }
            })
            
            
            
            // MARK: - KEYWORDS
            +++ Section("KEYWORDS")
            <<< TextAreaRow() { row in
                row.title = ""
                row.value = ""
                row.placeholder = "Set keywords to increase visibility in the store. They have to be consistent with the description and contents of your program. Think of what your potential clients might be looking for"
            }.onChange({ row in
                
                if let _value = row.value  {
                    self.program.tags.removeAll()
                    self.program.tags.append(contentsOf: _value.components(separatedBy: ", "))
                    self.program.tags = self.program.tags.filter({ !$0.isEmpty })
                    print("PTAGS: \(self.program.tags)")
                }
                
            })
            
            
            // MARK: - WOD INSTRUCTIONS
            +++ Section("WORKOUT DEFAULT INSTRUCTIONS")
            <<< TextAreaRow() { row in
                row.title = ""
                row.value = ""
                row.placeholder = "Tell your clients HOW te perform your workout. This tip will show in all workouts, but if you need, you can customize each one of them"
            }.onChange({ row in
                if let _value = row.value {
                    self.program.wod_instructions = _value.htmlConverted
                }
            })
            
            
            /// Price per workout
            +++ Section("PRICE PER WORKOUT FOR END USERS (PPW)")
            <<< PickerRow<String>("Picker Row") { (row : PickerRow<String>) -> Void in
                
                row.options = []
                for i in [50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000] {
                    row.options.append("\(i) W-COINS")
                }
            }.onChange({ row in
                if let _value = row.value {
                    if let _numeric = _value.components(separatedBy: " ").first {
                        if let _intValue = Int(_numeric) {
                            self.program.price = _intValue
                            print("Price: \(self.program.price)")
                        }
                    }
                }
            })
            
            +++ Section("Store Group")
            
            
            // MARK: - MAIN CATEGORY
            <<< ActionSheetRow<String>() { row in
                row.title = "CATEGORY"
                row.selectorTitle = "Choose"
                row.options = Program.mainCategories()
                row.value = "Select one"
            }.onChange({ row in
                if let _value = row.value {
                    self.program.main_category = _value.replacingOccurrences(of: " ", with: "_")
                    print("PCATEGORY: \(self.program.main_category)")
                }
            })
            
            
            +++ Section("Metadata")
            <<< TextRow() { row in
                row.title = "Author"
                row.value = "WodPod LAB"
                row.add(rule: RuleRequired())
                row.disabled = true
            }
            
            
            <<< SwitchRow("active"){
                $0.title = "Ready for Sale"
                $0.value = self.program.active
            }.onChange({ row in
                self.program.active = row.value ?? false
            })
            
            
            +++ Section("Main Image")
            <<< ImageRow() { row in
                row.title = "Choose an Image"
                row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                row.clearAction = .yes(style: UIAlertAction.Style.destructive)
                row.allowEditor = true
                row.useEditedImage = true
                
            }.onPresent({ (controller, pickerController) in
                
                pickerController.allowsEditing = true
                print(pickerController)
            }).onChange({ row in
                if let _image = row.value {
                    
                    let indicator = MaterialActivityIndicatorView()
                    indicator.startAnimating()
                    
                    // Create a root reference
                    let storageRef = self.storage.reference()
                    
                    // Create file metadata including the content type
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpeg"

                    // Create a reference to "mountains.jpg"
                    let programRef = storageRef.child("program_images/\(self.program.id ?? "").jpg")
                    let data =  _image.jpegData(compressionQuality: 1)
                    // Upload the fileto the path "images/rivers.jpg"
                    let uploadTask = programRef.putData(data!, metadata: metadata) { (metadata, error) in
                     
                    guard let metadata = metadata else {
                        // Uh-oh, an error occurred!
                        return
                      }
                      // Metadata contains file metadata such as size, content-type.
//                      let size = metadata.size
                      // You can also access to download URL after upload.
                      programRef.downloadURL { (url, error) in
                        indicator.stopAnimating()
                        
                        guard let downloadURL = url else {
                          // Uh-oh, an error occurred!
                          return
                        }
                        self.program.images = downloadURL.absoluteString
                        
                      }
                    }
                    
                    uploadTask.resume()

                    // Add a progress observer to an upload task
                    let observer = uploadTask.observe(.progress) { snapshot in
                      // A progress event occured
                        
                        print(snapshot)
                        
                    }

                    
                    print(_image)
                }
            })
        
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                               header: "Add Wods to Program",
                               footer: ".Insert adds a 'Add Item' (Add New Tag) button row as last cell.") { sec in
                                sec.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add a WOD"
                                    }
                                }
                                sec.tag = "wods_creator"
                                sec.multivaluedRowToInsertAt = { index in
                                    return WodPresenterRow() { row in
                                        row.title = "DAY \(index + 1)"
                                        row.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                                            return WodDetailViewController(wod: Wod(JSON.null), index: index + 1, programId: self.program.id, programType: self.programType)
                                            }, onDismiss: { vc in
                                                print(vc)
                                                if let _vc = vc as? WodDetailViewController {
                                                    self.program.wods.append(_vc.wod)
                                                }
                                                _ = vc.navigationController?.popViewController(animated: true)
                                        })
                                    }
                                }
                                
                                
                                
                                self.program.wods.enumerated().forEach { index, wod in
                                    
                                    sec.append(WodPresenterRow() { row in
                                        row.title = "DAY \(index + 1)"
                                        row.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                                            return WodDetailViewController(wod: wod, index: index + 1, programId: self.program.id, programType: self.programType)
                                            }, onDismiss: { vc in
                                                print(vc)
                                                if let _vc = vc as? WodDetailViewController {
                                                    self.program.wods.append(_vc.wod)
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
                $0.title = "PREVIEW"
                
            }.onCellSelection({ (cell, row) in
                
                firstly {
                    FireSession.shared.saveProgram(with: self.program)
                }.compactMap { saved in
                    Messages.shared.showCompleted()
                    self.navigationController?.popViewController(animated: true)
                }.catch { (error) in
                    Messages.shared.showError(error.localizedDescription)
                }

            })
        
    }
    
    @objc func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc
    fileprivate func removeTapped() {
        print("implement delete")
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    

    
}
