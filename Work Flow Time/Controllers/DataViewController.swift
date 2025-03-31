//
//  DataViewController.swift
//  Work Flow Time
//
//  Created by Александр Прохоров on 22.03.2022.
//

import UIKit

class DataViewController: UIViewController {
    var id = 0
    var testLabel = UILabel()
    

    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        testLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 40)
        testLabel.text = "testing text for testLabel on our VIEW"
        view.addSubview(testLabel)
        
        
    }
    

    

}
