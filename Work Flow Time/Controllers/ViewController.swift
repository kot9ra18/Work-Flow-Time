//
//  ViewController.swift
//  Work Flow Time
//
//  Created by Александр Прохоров on 22.03.2022.
//

import UIKit
import RealmSwift

protocol VCDelegate{
    func update(data: FolderTasksModelRealm)
}

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var startButtonOutlet: UIButton!
    @IBOutlet weak var stopButtonOutlet: UIButton!
    
    open var delegate: VCDelegate?
    
    let workTaskCell = "workTaskIdCell"
    var timer = Timer()
    var durationSec = 0
    var durationMin = 0
    var durationHour = 0
    
    var realm = try! Realm()
    var result: Results<FolderTasksModelRealm>?
    var resultTasks: Results<TimeWorkModelRealm>?
    
    
    //  MARK: - Buttons (start and stop)
    
    @IBAction func startButtonAction(_ sender: Any) {
        self.startButtonOutlet.isEnabled = false
        UIView.animate(withDuration: 1) {
            self.startButtonOutlet.isHidden = true
            self.startButtonOutlet.layoutIfNeeded()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(actionTimer), userInfo: nil, repeats: true)
        
        self.durationSec = 0
        self.durationMin = 0
        self.durationHour = 0
    }
    
    @IBAction func stopButonAction(_ sender: Any) {
        timer.invalidate()
        addAlertController()        
        
    }
    
    //  MARK: set value for label func
    @objc func actionTimer(){

        durationSec += 1
        timeLabel.text = "\(durationHour):\(durationMin):\(durationSec)"
       
        if durationSec > 9 {
            durationSec = 0
            durationMin += 1
            timeLabel.text = "\(durationHour):\(durationMin):\(durationSec)"
        }
        if durationMin > 9 {
            durationMin = 0
            durationHour += 1
            timeLabel.text = "\(durationHour):\(durationMin):\(durationSec)"
        }
       
    }
    
    // MARK: - Alert
    func addAlertController(){
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
            guard let textMain = alertMainTextField.text, !textMain.isEmpty else {return}
            guard let textTask = alertTaskTextField.text, !textTask.isEmpty else {return}

            self.timer.invalidate()
            
                let task = TimeWorkModelRealm.create(withName: textTask)
            task.totalTimeTask = "\(self.durationHour):\(self.durationMin):\(self.durationSec)"
            let mainTask = FolderTasksModelRealm.create(withName: textMain, nameWork: textTask, tasks: [task])
            
                // Write to Realm
                print("Write to Realm")
            try! self.realm.write {
                self.realm.add(task)
                self.realm.add(mainTask)
                }
            self.tableView.reloadData()
            
            self.timeLabel.text = "0"
            self.startButtonOutlet.isEnabled = true
            UIView.animate(withDuration: 0.3) {
                self.startButtonOutlet.isHidden = false
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { cancel in
            self.timer.invalidate()
            self.timeLabel.text = "0"
            self.startButtonOutlet.isEnabled = true
            UIView.animate(withDuration: 0.3) {
                self.startButtonOutlet.isHidden = false
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        startButtonOutlet.layer.cornerRadius = 50
        stopButtonOutlet.layer.cornerRadius = 50

        
        let path = Realm.Configuration.defaultConfiguration.fileURL
        // ///Users/aleksandrprohorov/Library/Developer/CoreSimulator/Devices/48933724-22CA-44B3-A9B6-D6D6A45B9A69/data/Containers/Data/Application/8881CC77-A83A-48D8-BE2D-3C97694D7310/Documents/default.realm
        
        result = realm.objects(FolderTasksModelRealm.self)
        resultTasks = realm.objects(TimeWorkModelRealm.self)
        
    }
}


// MARK: - EXTENSION tableView

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: workTaskCell) as! FolderCell
        
        cell.initCell(data: realm.objects(FolderTasksModelRealm.self)[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoForTasksViewController = self.storyboard?.instantiateViewController(withIdentifier: "Info") as! TimesForWorkViewController
        
        infoForTasksViewController.id = indexPath.row
        
        self.present(infoForTasksViewController, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        let editingRow = result?[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _, _ in
            try! self.realm.write({
                self.realm.delete(editingRow!)
                tableView.reloadData()
            })
        }
        return [deleteAction]
    }
    

    
}
