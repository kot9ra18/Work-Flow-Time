//
//  ViewController.swift
//  Work Flow Time
//
//  Created by Александр Прохоров on 22.03.2022.
//

import UIKit
import RealmSwift

protocol TimesForWorkVCDelegate: AnyObject{
    func didUpdateData(data: Int)
}


class ViewController: UIViewController, TimesForWorkViewControllerDelegate {
    
    func timesForWorkViewControllerDidSaveData() {
        // Обновление массива result с новыми данными из Realm
              result = realm.objects(FolderTasksModelRealm.self)
              
              // Перезагрузка таблицы, чтобы отобразить новые данные
              tableView.reloadData()
    }

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var startButtonOutlet: UIButton!
    @IBOutlet weak var stopButtonOutlet: UIButton!
        
    let workTaskCell = "workTaskIdCell"
    var timer = Timer()
    var durationSec = 0
    var durationMin = 0
    var durationHour = 0
    
    var realm = try! Realm()
    var result: Results<FolderTasksModelRealm>?
    var resultWorks: Results<TimeWorkModelRealm>?
    
    var timer2 = TimerManager.shared
 
    
    
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
        timeLabel.text = String(format: "%02d:%02d:%02d", durationHour, durationMin, durationSec)

        if durationSec > 59 {
            durationSec = 0
            durationMin += 1
            timeLabel.text = String(format: "%02d:%02d:%02d", durationHour, durationMin, durationSec)
        }
        if durationMin > 59 {
            durationMin = 0
            durationHour += 1
            timeLabel.text = String(format: "%02d:%02d:%02d", durationHour, durationMin, durationSec)
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
            guard let folderName = alertMainTextField.text, !folderName.isEmpty else {return}
            guard let workName = alertTaskTextField.text, !workName.isEmpty else {return}

            self.timer.invalidate()
            
                let task = TimeWorkModelRealm.create(withName: workName)
            task.totalTimeTask = "\(self.durationHour):\(self.durationMin):\(self.durationSec)"
            let mainTask = FolderTasksModelRealm.create(withName: folderName, nameWork: workName, tasks: [task])
            
                // Write to Realm
                print("Write to Realm")
            try! self.realm.write {
                self.realm.add(task)
                self.realm.add(mainTask)
                }
            self.tableView.reloadData()
            
            self.timeLabel.text = "00:00:00"
            self.startButtonOutlet.isEnabled = true
            UIView.animate(withDuration: 0.3) {
                self.startButtonOutlet.isHidden = false
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { cancel in
            self.timer.invalidate()
            self.timeLabel.text = "00:00:00"
            self.startButtonOutlet.isEnabled = true
            UIView.animate(withDuration: 0.3) {
                self.startButtonOutlet.isHidden = false
            }
        }
                
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func setupViews(){
        timeLabel.text = "00:00:00"
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 36, weight: .bold)
        timeLabel.textAlignment = .center
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        startButtonOutlet.setTitle("Старт", for: .normal)
        startButtonOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        startButtonOutlet.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.7) // Мягкий зеленый цвет
        startButtonOutlet.setTitleColor(.white, for: .normal)
        startButtonOutlet.layer.cornerRadius = 15 // Закругленные углы
        startButtonOutlet.layer.shadowColor = UIColor.black.cgColor // Цвет тени
        startButtonOutlet.layer.shadowOpacity = 0.3 // Прозрачность тени
        startButtonOutlet.layer.shadowOffset = CGSize(width: 0, height: 5) // Смещение тени
        startButtonOutlet.layer.shadowRadius = 10 // Радиус тени
        startButtonOutlet.translatesAutoresizingMaskIntoConstraints = false
        
        
        stopButtonOutlet.setTitle("Стоп", for: .normal)
        stopButtonOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        stopButtonOutlet.backgroundColor = UIColor.systemRed.withAlphaComponent(0.7) // Мягкий красный цвет
        stopButtonOutlet.setTitleColor(.white, for: .normal)
        stopButtonOutlet.layer.cornerRadius = 15 // Закругленные углы
        stopButtonOutlet.layer.shadowColor = UIColor.black.cgColor // Цвет тени
        stopButtonOutlet.layer.shadowOpacity = 0.3 // Прозрачность тени
        stopButtonOutlet.layer.shadowOffset = CGSize(width: 0, height: 5) // Смещение тени
        stopButtonOutlet.layer.shadowRadius = 10 // Радиус тени
        stopButtonOutlet.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        timeLabel.text = String(format: "%02d:%02d:%02d:%03d") //"00:00:00"

        
        let path = Realm.Configuration.defaultConfiguration.fileURL
        //print("________-----------____________", path)
        // ///Users/aleksandrprohorov/Library/Developer/CoreSimulator/Devices/48933724-22CA-44B3-A9B6-D6D6A45B9A69/data/Containers/Data/Application/0B01E835-60E9-49D6-8519-DA450203BE81/Documents/default.realm
        
        result = realm.objects(FolderTasksModelRealm.self)
        resultWorks = realm.objects(TimeWorkModelRealm.self)
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
       //print(realm.objects(FolderTasksModelRealm.self).description)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let infoForTasksViewController = self.storyboard?.instantiateViewController(withIdentifier: "Info") as! TimesForWorkViewController

        infoForTasksViewController.delegate = self
        infoForTasksViewController.id = indexPath.row
        navigationController?.pushViewController(infoForTasksViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { [weak self] (_, indexPath) in
            guard let self = self, let editingRow = self.result?[indexPath.row] else {
                return
            }
            
            do {
                try self.realm.write {
                    self.realm.delete(editingRow)
                }
                // Не вызываем tableView.reloadData() здесь, так как Realm сам обрабатывает удаление данных
            } catch {
                print("Error deleting object: \(error)")
            }
        }
        
        // Можно также добавить другие действия (например, "Изменить" или "Поделиться")
        let addAction = UITableViewRowAction(style: .destructive, title: "ADD") { indexPath, _ in
            print("все получилсь")
 
        }
        return [deleteAction]
    }
}

extension ViewController: TimesForWorkVCDelegate{
    func didUpdateData(data: Int) {
        // присвоить значение?
        tableView.reloadData()
    }
}
