//
//  GhostViewController.swift
//  WodPodLab
//
//  Created by Hugo Perez on 24/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import UIKit
import PromiseKit
import Charts

class GhostViewController: UIViewController, ChartViewDelegate {
    
    var ghostData: [Ghost] = []
    
    var user: User!
     
     init(user: User) {
         super.init(nibName: nil, bundle: nil)
         self.user = user
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    
    @IBOutlet weak var noData: UILabel!
    
    
    @IBOutlet weak var meanLabel: UILabel!
    
    @IBOutlet weak var partialLabel: UILabel!
    
    @IBOutlet weak var intervalLabel: UILabel!
    
    @IBOutlet weak var totalRepsLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    
    
    @IBOutlet weak var barChart: BarChartView! {
        didSet {
            barChart.gridBackgroundColor = UIColor.white.withAlphaComponent(0.5)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Ghost Data"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        barChart.delegate = self
        
        self.getData()
        
        // Do any additional setup after loading the view.
    }
    
    fileprivate func getData() {
        
        firstly {
            FireSession.shared.getGhostData(for: self.user.id)
        }.compactMap { data  in
            self.ghostData.removeAll()
            if data.isEmpty {
                self.noData.isHidden = false
                self.barChart.isHidden = true
                self.meanLabel.isHidden = true
                self.partialLabel.isHidden = true
                self.intervalLabel.isHidden = true
                self.totalRepsLabel.isHidden = true
                self.detailLabel.isHidden = true
            }
            self.ghostData = data.sorted(by: {
                $0.displayName < $1.displayName
            })
        }.catch { (error) in
            Messages.shared.showError(error.localizedDescription)
        }.finally {
            self.barChartUpdate()
        }
        
    }

    
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
        
       
        print(self.ghostData[Int(entry.x)].displayName)
        self.title = self.ghostData[Int(entry.x)].displayName
        meanLabel.text = "MEAN: \(String(format: "%.3f", self.ghostData[Int(entry.x)].mean))"
        partialLabel.text = "PARTIAL: \(Int(self.ghostData[Int(entry.x)].partial).toTimeParts().description)"
        intervalLabel.text = "INTERVAL: \(self.ghostData[Int(entry.x)].interval)"
        totalRepsLabel.text = "TOTAL REPS: \(self.ghostData[Int(entry.x)].allReps + Int(self.ghostData[Int(entry.x)].interval) / 3)"
        
        

        
    }
    
    
    

}
