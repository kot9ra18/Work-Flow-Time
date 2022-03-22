//
//  WorkTaskCell.swift
//  Work Flow Time
//
//  Created by Александр Прохоров on 22.03.2022.
//

import UIKit

class WorkTaskCell: UITableViewCell {
    
    let workTaskIdCell = "workTaskIdCell"
    
    @IBOutlet weak var nameTask: UILabel!
    @IBOutlet weak var totalTimeForThisTask: UILabel!
    
    
    
    

   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
