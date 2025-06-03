//
//  WorkTaskModelRealm.swift
//  Work Flow Time
//
//  Created by Александр Прохоров on 26.03.2022.
//

import Foundation
import RealmSwift

class TimeWorkModelRealm: Object {
    @objc dynamic var nameList: FolderTasksModelRealm?
    
    @objc dynamic var nameTask = ""
    @objc dynamic var totalTimeSec = 0
    @objc dynamic var totalTimeMin = 0
    @objc dynamic var totalTimeHour = 0
    @objc dynamic var totalTimeTask = ""
    
    static func create(withName name: String) -> TimeWorkModelRealm {
        let task = TimeWorkModelRealm()
        task.nameTask = name
        
        return task
    }
    
    func addTime(second: Int) -> String{
        totalTimeSec = totalTimeSec + second
        totalTimeMin = totalTimeSec / 60
        totalTimeHour = totalTimeSec / 3600
        return "\(totalTimeHour), \(totalTimeMin), \(totalTimeSec - (totalTimeHour * 3600) - (totalTimeMin * 60))"
    }
    
    func addTotalTime(sec: Int, min: Int, hour: Int) -> String {
        totalTimeSec = totalTimeSec + sec
        if totalTimeSec > 59 {totalTimeMin += 1}
        
        totalTimeMin = totalTimeMin + min
        if totalTimeMin > 59 {totalTimeHour += 1}
        
        totalTimeHour = totalTimeHour + hour
        
        return "\(totalTimeHour):\(totalTimeMin):\(totalTimeSec)"
    }

}


