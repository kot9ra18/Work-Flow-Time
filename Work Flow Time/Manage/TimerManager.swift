//
//  TimerManager.swift
//  Work Flow Time
//
//  Created by Александр Прохоров on 31.03.2025.
//


import Foundation
import RealmSwift

class TimerManager {
    
    // Singleton instance
    static let shared = TimerManager()
    
    private var timer: Timer?
    private var startTime: Date?
    private var elapsedTime: TimeInterval = 0
    
    func startTimer() {
        if timer == nil {
            startTime = Date()
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    @objc private func updateTimer() {
        guard let startTime = startTime else { return }
        elapsedTime = Date().timeIntervalSince(startTime)
    }
    
    func invTimer(){
        self.timer?.invalidate()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        // Save the result to Realm here
        saveElapsedTime(elapsedTime)
        
        elapsedTime = 0
        startTime = nil
    }
    
    private func saveElapsedTime(_ time: TimeInterval) {
        // Сохранение результата в Realm
        let realm = try! Realm()
       // let record = WorkSession(value: ["elapsedTime": time])
        try! realm.write {
           // realm.add(record)
        }
    }
}
