//
//  FolderTasksModelRealm.swift
//  Work Flow Time
//
//  Created by Александр Прохоров on 13.03.2025.
//

import Foundation
import RealmSwift

class FolderTasksModelRealm: Object{
        var timeWorks = List<TimeWorkModelRealm>()
        @objc dynamic var nameArrayTask = ""
        @objc dynamic var nameWorkTask = ""
        @objc dynamic var timeThemes = 0
    
    func addTotalTimeWorkThemes(data: [TimeWorkModelRealm]) {
        for i in data {
            timeThemes += Int(i.totalTimeTask) ?? 99
        }   
    }

    static func create(withName name: String, nameWork work: String, tasks: [TimeWorkModelRealm]) -> FolderTasksModelRealm {
        let tasksArr = FolderTasksModelRealm()
        tasksArr.nameArrayTask = name
        tasksArr.nameWorkTask = work
        
        tasksArr.timeWorks.append(objectsIn: tasks)
        
        return tasksArr
    }
    
    func update(task: TimeWorkModelRealm){
        timeWorks.append(task)
    }
    
    
}
