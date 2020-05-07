//
//  MovsCell.swift
//  WodPodLab
//
//  Created by Hugo Perez on 29/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import UIKit
import Eureka

public class MovsCell: Cell<String>, CellType {
    
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var repsLabel: UILabel!
    
    public override func setup() {
        super.setup()
    }
    
    public override func update() {
        super.update()
        if nameLabel != nil {
            nameLabel.text = "TEST DATA"
        }
        
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// The custom Row also has the cell: CustomCell and its correspond value
public final class MovsRow: Row<MovsCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        
        var title: String = ""
        // We set the cellProvider to load the .xib corresponding to our cell
        cellProvider = CellProvider<MovsCell>(nibName: "MovsCell")
    }
}
