//
//  AlertTaskModel.swift
//  Work Flow Time
//
//  Created by Александр Прохоров on 26.03.2022.
//

import Foundation
import UIKit

//func addAlertController(){
//    let alert = UIAlertController(title: "New task", message: "Please to fill place", preferredStyle: .alert)
//    var alertTextField: UITextField!
//    alert.addTextField { textField in
//        alertTextField = textField
//    }
//    
//    let saveAction = UIAlertAction(title: "Save", style: .default) { action in
//        guard let text = alertTextField.text, !text.isEmpty else {return}
//    }
//    
//    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//    
//    alert.addAction(saveAction)
//    alert.addAction(cancelAction)
//    
//    alert.present(alert, animated: true, completion: nil)
//}

//func addAlertForNewItem() {
//            let alert = UIAlertController(title: "Новая задача", message: "Пожалуйста заполните поле", preferredStyle: .alert)
//
//    var alertTextField: UITextField!
//    alert.addTextField { textField in
//        alertTextField = textField
//    }
//
//    let saveAction = UIAlertAction(title: "Сохранить", style: .default) { action in
//
//        guard let text = alertTextField.text , !text.isEmpty else { return }
//
//        let task = TasksList()
//        task.task = text
//
//        try! self.realm.write {
//            self.realm.add(task)
//        }
//
//        self.tableView.insertRows(at: [IndexPath.init(row: self.items.count-1, section: 0)], with: .automatic)
//    }
//
//    let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
//
//    alert.addAction(saveAction)
//    alert.addAction(cancelAction)
//
//    present(alert, animated: true, completion: nil)
//}
