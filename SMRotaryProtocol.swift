//
//  SMRotaryProtocol.swift
//  RotatingWheelController
//
//  Created by tom on 12/11/18.
//  Copyright © 2018 tom. All rights reserved.
//

import UIKit

protocol SMRotaryProtocol {
    func viewFor(tag: Int) -> UIView
    func wheelDidChangeValue(to: Int)
}
