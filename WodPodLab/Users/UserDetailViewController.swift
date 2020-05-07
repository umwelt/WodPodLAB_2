//
//  UserDetailViewController.swift
//  WodPodLab
//
//  Created by Hugo Perez on 23/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import UIKit
import SwiftyJSON
import PromiseKit
import SnapKit
import Eureka
import Charts

class UserDetailViewController: FormViewController, ChartViewDelegate {
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        
        
        
        return imageView
    }()
    
    
    /// Movemements Chart
    lazy var barChart: BarChartView = {
        let barChart = BarChartView()
        barChart.gridBackgroundColor = UIColor.white.withAlphaComponent(0.5)
        barChart.tag = 111
        barChart.setScaleEnabled(false)
        return barChart
    }()
    
    /// Challenges chart
    
    lazy var performanceChart: HorizontalBarChartView = {
        let chart = HorizontalBarChartView()
        chart.backgroundColor = UIColor.darkGray
        chart.tag = 222
        chart.dragEnabled = false
        chart.setScaleEnabled(false)
        
        return chart
    }()
    
    
    let chartLabels: GhostLabelsView = GhostLabelsView()
    
    //let userSections: [String] = ["GHOST", "NOTIFICATIONS", "PROFILE", "PROGRAMS", "RECORDS", "STATS", "WODS"]
    var ghostData: [Ghost] = []
    
    var stats: Stats!
    
    var user: User!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getUserData()
        
        self.title = user.username
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        barChart.delegate = self
        performanceChart.delegate = self
        
    }
    
    
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                
                self.imageView.image = image
                self.imageView.contentMode = .scaleAspectFill
                self.imageView.layoutIfNeeded()
                self.imageView.clipsToBounds = true
                self.imageView.layer.cornerRadius = 150 / 2
                
            }
        }
    }
    
    var activeMovement: String = ""
    
    fileprivate func layoutForm() {
        form
            +++ Section("User Profile")
            
            <<< ViewRow<UIView>("view") { (row) in
                row.title = "Photo" // optional
            }
            .cellSetup { (cell, row) in
                //  Construct the view for the cell
                cell.view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 250))
                cell.view?.addSubview(self.imageView)
                
                self.imageView.snp.makeConstraints { (make) in
                    make.width.height.equalTo(150)
                    make.center.equalToSuperview()
                }
                
                self.imageView.layoutIfNeeded()
                self.imageView.clipsToBounds = true
                self.imageView.layer.cornerRadius = 150 / 2
            }
            
            +++ Section("User Data")
            
            
            <<< TextRow(){ row in
                row.title = "Email"
                row.value = user.email
                row.disabled = true
            }
            
            <<< TextRow(){ row in
                row.title = "Name"
                row.value = user.name
                row.disabled = true
            }
            
            <<< TextRow(){ row in
                row.title = "Last Name"
                row.value = user.last_name
                row.disabled = true
            }
            
            <<< TextRow(){ row in
                row.title = "Username"
                row.value = user.username
                row.disabled = true
            }
            
            <<< TextRow(){ row in
                row.title = "Coins Balance"
                row.value = String(user.fitcoins)
                row.disabled = true
            }
            
            +++ Section("User Stats")
            
            <<< ViewRow<UIView>("barChart") { (row) in
                row.title = "Movement..." // optional
            }
            .cellSetup { (cell, row) in
                //  Construct the view for the cell
                cell.view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500))
                cell.view?.addSubview(self.barChart)
                
                self.barChart.snp.makeConstraints { (make) in
                    make.top.left.right.equalTo(0)
                    make.height.equalTo(250)
                }
                
                cell.view?.addSubview(self.chartLabels)
                self.chartLabels.snp.makeConstraints { (make) in
                    make.top.equalTo(self.barChart.snp.bottom)
                    make.left.right.equalTo(0)
                }
                
            }
            
            +++ Section("User Performance")
            
            <<< ViewRow<UIView>("performanceChart") { (row) in
                row.title = "1-Wod Challenge" // optional
            }
            .cellSetup { (cell, row) in
                //  Construct the view for the cell
                cell.view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400))
                cell.view?.addSubview(self.performanceChart)
                
                self.performanceChart.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
            
            +++ Section("Fitness Level")
            
            <<< TextRow() { row in
                row.tag = "f_level"
                row.title = "Level"
                row.value = "..."
                row.disabled = true
            }
                    
            <<< TextRow() { row in
                row.tag = "total_performance"
                row.title = "Total Activity"
                row.value = "..."
                row.disabled = true
            }
                
           
        }
        
    }
    



/// Challenges Stats data
extension UserDetailViewController  {
    
    fileprivate func setStatsChartData() {
        
        
        let completed = BarChartDataEntry(x: 0, y: Double(self.stats.challenges_completed))
        let created = BarChartDataEntry(x: 1, y: Double(self.stats.challenges_created))
        let taken = BarChartDataEntry(x: 2, y: Double(self.stats.challenges_taken))
        let won = BarChartDataEntry(x: 3, y: Double(self.stats.challenges_won))
        let p_com = BarChartDataEntry(x: 4, y: Double(self.stats.programs_completed))
        let p_mas = BarChartDataEntry(x: 5, y: Double(self.stats.programs_mastered))
        let w_com = BarChartDataEntry(x: 6, y: Double(self.stats.wods_completed))
        let w_mas = BarChartDataEntry(x: 7, y: Double(self.stats.wods_mastered))
        
        
        
        let set = BarChartDataSet(entries: [completed, created, taken, won, p_com, p_mas, w_com, w_mas])
        set.colors = ChartColorTemplates.colorful()
        
        let data = BarChartData(dataSet: set)
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.white)
        
        performanceChart.data = data
        performanceChart.highlightValues(nil)
        
    }
    
}


/// BAR CHART DELEGATE
extension UserDetailViewController {
    
    /// Bar Char
    func barChartUpdate() {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for (index, item) in self.ghostData.enumerated() {
            dataEntries.append(BarChartDataEntry(x: Double(index), y: Double(item.allReps) + (Double(item.interval) / 3), data: item.displayName))
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries, label: "Movements Performance")
        let data = BarChartData(dataSets: [dataSet])
        
        dataSet.colors = ChartColorTemplates.liberty()
        data.setValueTextColor(UIColor.white)
        
        barChart.data = data
        barChart.xAxis.drawLabelsEnabled = true
        barChart.xAxis.labelTextColor = UIColor.white
        
        barChart.chartDescription?.text = "All Reps per Movement"
        barChart.legend.textColor = UIColor.white
        barChart.leftAxis.labelTextColor = UIColor.white
        barChart.rightAxis.labelTextColor = UIColor.white
        
        
        //All other additions to this function will go here
        
        //This must stay at end of function
        barChart.notifyDataSetChanged()
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        if chartView.tag == 111 {
            if let _row = self.form.rowBy(tag: "barChart") {
                _row.title = self.ghostData[Int(entry.x)].displayName
                _row.reload()
            }
            self.chartLabels.mean.text = "Mean: \(String(format: "%.3f", self.ghostData[Int(entry.x)].mean))"
            self.chartLabels.trainingTime.text = "Training Time: \(Int(self.ghostData[Int(entry.x)].partial).toTimeParts().description)"
            self.chartLabels.interval.text = "Interval: \(self.ghostData[Int(entry.x)].interval)"
            self.chartLabels.allReps.text = "All Reps: \(self.ghostData[Int(entry.x)].allReps + Int(self.ghostData[Int(entry.x)].interval) / 3)"
        } else if chartView.tag == 222 {
            if let _row = self.form.rowBy(tag: "performanceChart") {
                
                switch entry.x {
                case 0:
                    _row.title = "Challenges Completed: \(self.stats.challenges_completed)"
                case 1:
                    _row.title = "Challenges Created: \(self.stats.challenges_created)"
                case 2:
                    _row.title = "Challenges Taken: \(self.stats.challenges_taken)"
                case 3:
                    _row.title = "Challenges Won: \(self.stats.challenges_won)"
                case 4:
                    _row.title = "Programs Completed: \(self.stats.programs_completed)"
                case 5:
                    _row.title = "Programs Mastered: \(self.stats.programs_mastered)"
                case 6:
                    _row.title = "Wods Completed: \(self.stats.wods_completed)"
                case 7:
                    _row.title = "Wods Mastered: \(self.stats.wods_mastered)"
                default:
                    _row.title = "User Stats"
                }
                
                
                _row.reload()
            }
            
            
            
            
        }
        
        
        
    }
    
    fileprivate func updateFitnessLevel() {
        if let _row = self.form.rowBy(tag: "f_level") {
            _row.title = "Level"
            _row.baseValue = self.stats.level.replacingOccurrences(of: "_", with: " ").uppercased()
            _row.reload()
        }
        
        if let _row = self.form.rowBy(tag: "total_performance") {
            _row.title = "Total Activity"
            _row.baseValue = "\(String(self.stats.wods_completed + self.stats.wods_mastered + self.stats.challenges_taken)) WODS"
            _row.reload()
        }
        
    }
    
    
    
}


extension UserDetailViewController {
    
    
    fileprivate func getStatsData() {
        
        firstly {
            FireSession.shared.getStatsData(for: self.user.id)
        }.map { data  in
            self.stats = data
        }.catch { (error) in
            Messages.shared.showError(error.localizedDescription)
        }.finally {
            self.setStatsChartData()
            self.updateFitnessLevel()
        }
        
    }
    
    fileprivate func getUserData() {
        
        firstly {
            FireSession.shared.getUserProfileData(for: self.user.id)
        }.map { user in
            self.user = user
        }.catch { (error) in
            Messages.shared.showError(error.localizedDescription)
        }.finally {
            
            self.layoutForm()
            self.setImage(from: self.user.photoURL)
            self.getData()
        }
        
    }
    
    fileprivate func getData() {
        
        firstly {
            FireSession.shared.getGhostData(for: self.user.id)
        }.compactMap { data  in
            self.ghostData.removeAll()
            if data.isEmpty {
                if let _row = self.form.rowBy(tag: "barChart") {
                    
                    _row.hidden = true
                    _row.evaluateHidden()
                }
                
            }
            self.ghostData = data.sorted(by: {
                $0.displayName < $1.displayName
            })
        }.catch { (error) in
            Messages.shared.showError(error.localizedDescription)
        }.finally {
            self.barChartUpdate()
            self.getStatsData()
        }
        
    }
}
