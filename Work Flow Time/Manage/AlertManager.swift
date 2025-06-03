//
//  AlertManager.swift
//  Work Flow Time
//
//  Created by Александр Прохоров on 01.04.2025.
//

import Foundation
import UIKit

class AlertManager {
    
    var timer = TimerManager.shared
    var realmManager = RealmManager.shared
    
    func addFoldAlertController(VC: UIViewController){
        let alert = UIAlertController(title: "New work", message: "Please to fill place", preferredStyle: .alert)
        
        var alertMainTextField: UITextField!
        alert.addTextField { textField in
            alertMainTextField = textField
        }
        var alertTaskTextField: UITextField!
        alert.addTextField { textField in
            alertTaskTextField = textField
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            guard let textFolder = alertMainTextField.text, !textFolder.isEmpty else {return}
            guard let textWork = alertTaskTextField.text, !textWork.isEmpty else {return}

            self.timer.invTimer()
            
            //                let task = TimeWorkModelRealm.create(withName: textTask)
            let work = TimeWorkModelRealm.create(withName: textWork)
            

//            task.totalTimeTask = "\(self.durationHour):\(self.durationMin):\(self.durationSec)"
            
//            let mainTask = FolderTasksModelRealm.create(withName: textMain, nameWork: textTask, tasks: [task])
            let folder = FolderTasksModelRealm.create(withName: textFolder, nameWork: textWork, tasks: [work])
            
                // Write to Realm
//                print("Write to Realm")
//            try! self.realm.write {
//                self.realm.add(task)
//                self.realm.add(mainTask)
//                }
            //проверка существующего имени и сохранение новых данных
            if self.realmManager.chekNamesExists(name: folder.nameArrayTask){
                let alert = UIAlertController(title: "Name is exists", message: "Please change name folder", preferredStyle: .alert)
                alert.show(VC, sender: nil)
            }else{
                self.realmManager.saveFolderRealm(folder: folder, work: work)
            }
            
//            self.tableView.reloadData()
//
//            self.timeLabel.text = "00:00:00"
//            self.startButtonOutlet.isEnabled = true
//            UIView.animate(withDuration: 0.3) {
//                self.startButtonOutlet.isHidden = false
            }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { cancel in
//            self.timer.invalidate()
            self.timer.invTimer()
//            self.timeLabel.text = "00:00:00"
//            self.startButtonOutlet.isEnabled = true
//            UIView.animate(withDuration: 0.3) {
//                self.startButtonOutlet.isHidden = false
            }
        
        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
        VC.present(alert, animated: true, completion: nil)
    }
    
    func addWorkAlertController(VC: UIViewController, id: Int){
      let alert = UIAlertController(title: "New work", message: "Please to fill place", preferredStyle: .alert)

      var alertTaskTextField: UITextField!
      alert.addTextField { textField in
          alertTaskTextField = textField
      }
      
      let saveAction = UIAlertAction(title: "Save", style: .default) { action in
          guard let textWork = alertTaskTextField.text, !textWork.isEmpty else {return}

          //self.timerWork.invalidate()

              let work = TimeWorkModelRealm.create(withName: textWork)
          
          //task.totalTimeTask = "\(self.durationHour):\(self.durationMin):\(self.durationSec)"
          
              // Write to Realm
//              print("Write to Realm")
//          try! self.realm.write {
//              self.realm.add(task)
//              self.resultFolder[self.id].timeWorks.append(task)
//              }
          self.realmManager.saveWorkRealm(work: work, id: id)
         
        //  print(task)
        //  self.tableViewInfo.reloadData()
          
          
//          self.timeNewTaskLabel.text = "00:00:00"
//          self.startNewTaskButtonOutlet.isEnabled = true
//          UIView.animate(withDuration: 0.3) {
//              self.startNewTaskButtonOutlet.isHidden = false
//          }
          
         // self.tableViewInfo.reloadData()
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .default) { cancel in
//          self.timerWork.invalidate()
          self.timer.invTimer()
//          self.timeNewTaskLabel.text = "00:00:00"
//          self.startNewTaskButtonOutlet.isEnabled = true
//          UIView.animate(withDuration: 0.3) {
//              self.startNewTaskButtonOutlet.isHidden = false
//          }
      }
      
      alert.addAction(saveAction)
      alert.addAction(cancelAction)
      VC.present(alert, animated: true, completion: nil)
  }
    
    
}
