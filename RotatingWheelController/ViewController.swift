//
//  ViewController.swift
//  RotatingWheelController
//
//  Created by tom on 12/11/18.
//  Copyright © 2018 tom. All rights reserved.
//

import os
import UIKit

class ViewController: UIViewController, SMRotaryProtocol {
    func wheelDidChangeValue(to: Int) {
        os_log(OSLogType.default, "%d", to);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let wheel = SMRotaryWheel(frame: view.frame, delegate: self, numberOfSections: 3)
        view.addSubview(wheel)
    }


}

