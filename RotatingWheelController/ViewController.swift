//
//  ViewController.swift
//  RotatingWheelController
//
//  Created by tom on 12/11/18.
//  Copyright © 2018 tom. All rights reserved.
//

import os
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let wheel = SMRotaryWheel(frame: view.frame, delegate: self, numberOfSections: 3)
        view.addSubview(wheel)
    }
}

extension ViewController : SMRotaryProtocol {
    func viewFor(tag: Int) -> UIView {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        view.backgroundColor = .red
        view.tag = tag
        view.text = "\(tag)"
        return view
    }

    func wheelDidChangeValue(to: Int) {
        print("\(to)")
    }
}

