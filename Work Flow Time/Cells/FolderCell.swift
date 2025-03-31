//
//  WorkTaskCell.swift
//  Work Flow Time
//
//  Created by Александр Прохоров on 22.03.2022.
//

import UIKit

class FolderCell: UITableViewCell {
    
    let workTaskIdCell = "workTaskIdCell"
    
    @IBOutlet weak var nameTask: UILabel!
    @IBOutlet weak var worksCount: UILabel!
    
    func initCell(data: FolderTasksModelRealm){
        nameTask.text = data.nameArrayTask
        worksCount.text = String(data.timeWorks.count)
        //totalTimeForThisTask.text = String(data.timeThemes)
       // totalTimeForThisTask.text = "\(data.totalTimeHour):\(data.totalTimeMin):\(data.totalTimeSec)"
    }
    
    

   
    

}
