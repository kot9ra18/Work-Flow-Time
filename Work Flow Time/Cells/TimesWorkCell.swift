//
//  InfoForTask.swift
//  Work Flow Time
//
//  Created by Александр Прохоров on 29.03.2022.
//

import UIKit

class TimesWorkCell: UITableViewCell {

    
    @IBOutlet weak var dateInfoLabel: UILabel!
    @IBOutlet weak var timeInfoLabel: UILabel!
    
    func initCell(data: TimeWorkModelRealm){
        dateInfoLabel.text = data.nameTask
        timeInfoLabel.text = data.totalTimeTask
        //totalTimeForThisTask.text = String(data.timeThemes)
       // totalTimeForThisTask.text = "\(data.totalTimeHour):\(data.totalTimeMin):\(data.totalTimeSec)"
    }
    
    
  

}
