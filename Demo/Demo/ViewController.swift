//
//  ViewController.swift
//  Demo
//
//  Created by tailang on 3/9/16.
//  Copyright © 2016 com.ecoolhud.TLTimeButton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var timeButton: TLTimeButton = {
        
        let button = TLTimeButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50),
            timeLine: 30,
            originTitle: "获取验证码",
            finishTitle: nil,
            timeRunningUnit: "s",
            enableColor: UIColor.redColor(),
            disableColor: UIColor.grayColor())
        
        button.delegate = self as TLTimeButtonDelegate
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       view.addSubview(timeButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: TLTimeButtonDelegate {
    
    func timeWillRun() {
        print("TLTimeButton will run...")
    }
    
    func timeRunning(currentTime: Int) {
        print("TLTimeButton is running, current time is \(currentTime)")
    }
    
    func timeDidRun() {
        print("TLTimeButton finish")
    }
    
}
