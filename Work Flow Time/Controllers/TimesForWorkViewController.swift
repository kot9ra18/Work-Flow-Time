//
//  InfoForDataViewController.swift
//  Work Flow Time
//
//  Created by Александр Прохоров on 22.03.2022.
//

import UIKit
import RealmSwift
//import CloudKit

class TimesForWorkViewController: UIViewController, VCDelegate {
    func update(data: FolderTasksModelRealm) {
        
    }
    
    
    var arrNameWork: [String] = []
    var arrTimeWork: [String] = []
    
    private let realm = try! Realm()
    let idCell = "infoForTask"
    
    @IBOutlet weak var tableViewInfo: UITableView!
    @IBOutlet weak var timeNewTaskLabel: UILabel!
    @IBOutlet weak var stopNewTaskButtonOutlet: UIButton!
    @IBOutlet weak var startNewTaskButtonOutlet: UIButton!
    
    var id = Int()
    var timerWork = Timer()
    var result: Results<TimeWorkModelRealm>!
    var resultFolder: Results<FolderTasksModelRealm>!
    
    var durationHour = Int()
    var durationMin = Int()
    var durationSec = Int()

    var titleTask = "123"
    
    
    @IBAction func startNewTaskButtonAction(_ sender: Any) {
        startNewTaskButtonOutlet.isEnabled = false
        
        timerWork = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(actionTimer), userInfo: nil, repeats: true)

    }
    
    @IBAction func stopNewTaskButtonAction(_ sender: Any) {
        timerWork.invalidate()
        addAlertController()
    }
    
    //  MARK: set value for label func
    @objc func actionTimer(){

        durationSec += 1
        timeNewTaskLabel.text = "\(durationHour):\(durationMin):\(durationSec)"

        if durationSec > 9 {
            durationSec = 0
            durationMin += 1
            timeNewTaskLabel.text = "\(durationHour):\(durationMin):\(durationSec)"
        }
        if durationMin > 9 {
            durationMin = 0
            durationHour += 1
            timeNewTaskLabel.text = "\(durationHour):\(durationMin):\(durationSec)"
        }
       
    }
    
   let context = UIContextualAction()
    
    func addAlertController(){
        let alert = UIAlertController(title: "New work", message: "Please to fill place", preferredStyle: .alert)

        var alertTaskTextField: UITextField!
        alert.addTextField { textField in
            alertTaskTextField = textField
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            guard let textTask = alertTaskTextField.text, !textTask.isEmpty else {return}

            self.timerWork.invalidate()

                let task = TimeWorkModelRealm.create(withName: textTask)
            task.totalTimeTask = "\(self.durationHour):\(self.durationMin):\(self.durationSec)"
            
                // Write to Realm
                print("Write to Realm")
            try! self.realm.write {
                self.realm.add(task)
                self.resultFolder[self.id].timeWorks.append(task)
                // self.realm.add(mainTask)
                }
            print(task)
            self.tableViewInfo.reloadData()
            
            
            self.timeNewTaskLabel.text = "0"
            self.startNewTaskButtonOutlet.isEnabled = true
            UIView.animate(withDuration: 0.3) {
                self.startNewTaskButtonOutlet.isHidden = false
            }
            self.tableViewInfo.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { cancel in
            self.timerWork.invalidate()
            self.timeNewTaskLabel.text = "0"
            self.startNewTaskButtonOutlet.isEnabled = true
            UIView.animate(withDuration: 0.3) {
                self.startNewTaskButtonOutlet.isHidden = false
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //  MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentationController?.delegate = self
        
        self.startNewTaskButtonOutlet.layer.cornerRadius = 20
        self.stopNewTaskButtonOutlet.layer.cornerRadius = 20
        self.title = titleTask
        
        self.result = realm.objects(TimeWorkModelRealm.self)
        self.resultFolder = realm.objects(FolderTasksModelRealm.self)
        
    }
    
   
    
}

//MARK: - EXTENTION

extension TimesForWorkViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultFolder[id].timeWorks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewInfo.dequeueReusableCell(withIdentifier: idCell) as! TimesWorkCell
        let ip = resultFolder[id].timeWorks
        let op = ip[indexPath.row]
    
        cell.dateInfoLabel.text = op.nameTask
        cell.timeInfoLabel.text = op.totalTimeTask
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        let editingRow = resultFolder[id].timeWorks[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _, _ in
            try! self.realm.write({
                self.realm.delete(editingRow)
                tableView.reloadData()
            })
        }
        
       
        
        return [deleteAction]
    }
    
    

    
    
}

extension TimesForWorkViewController: UIAdaptivePresentationControllerDelegate{
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print(#function)
    }
}
