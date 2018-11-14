//
//  SMRotaryWheel.swift
//  RotatingWheelController
//
//  Created by tom on 12/11/18.
//  Copyright © 2018 tom. All rights reserved.
//

import UIKit

class SMRotaryWheel: UIControl {
    var delegate: SMRotaryProtocol?
    var container: UIView?
    var numberOfSections: Int?
    var startTransform = CGAffineTransform.identity
    var deltaAngle: CGFloat?
    var sectors: [SMSector<Int>] = []
    var currentSector: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, delegate: SMRotaryProtocol, numberOfSections: Int) {
        super.init(frame: frame)
        self.delegate = delegate
        self.numberOfSections = numberOfSections
        self.setup()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        let dist = calculateDistanceFromCentre(point: touchPoint)
        if dist < 40 || dist > 400 {
            return false
        }
        guard let container = container else {
            return false
        }
        
        let dx = touchPoint.x - container.center.x
        let dy = touchPoint.y - container.center.y
        deltaAngle = atan2(dy, dx)
        startTransform = container.transform

        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard let container = container, let deltaAngle = deltaAngle else {
            return false
        }
        
        let touchPoint = touch.location(in: self)
        let dx = touchPoint.x - container.center.x
        let dy = touchPoint.y - container.center.y
        let angle = atan2(dy, dx)
        let angleDifference = deltaAngle - angle
        container.transform = startTransform.rotated(by: -angleDifference)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard let container = container else {
            return
        }
        
        let transformAngle = atan2(container.transform.b, container.transform.a)
        guard let sector = sectors.first(where: {$0.contains(transformAngle)}) else {
            return
        }
        
        let newVal = CGFloat(transformAngle - sector.middle)
        currentSector = sector.value
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        container.transform = container.transform.rotated(by: -newVal)
        UIView.commitAnimations()
        
        delegate?.wheelDidChangeValue(to: currentSector)
    }
    
    func calculateDistanceFromCentre(point: CGPoint) -> CGFloat {
        let centre = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let dx = point.x - centre.x
        let dy = point.y - centre.y
        return (dx * dx + dy * dy).squareRoot()
    }

    func setup() {
        container = UIView(frame: frame)
        guard let container = container, let delegate = delegate, let numberOfSections = numberOfSections else {
            return
        }
        
        let sectorAngle = 2 * CGFloat.pi / CGFloat(numberOfSections)
        var upper = sectorAngle / 2.0
        
        for i in 0..<numberOfSections {
            // Create and add view to container
            let view = delegate.viewFor(tag: i)
            view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            view.layer.position = CGPoint(x: container.bounds.size.width / 2.0, y: container.bounds.size.height / 2.0)
            view.transform = CGAffineTransform(rotationAngle: CGFloat(i) * sectorAngle)
            
            container.addSubview(view)
            
            // Create and add sector slice information
            if upper == -CGFloat.pi {
                upper = CGFloat.pi
            }
            
            let lower = upper - sectorAngle
            if lower < -CGFloat.pi {
                sectors.append(SMSector<Int>(lower: -upper, upper: upper, value: i))
                upper = -upper
            } else {
                sectors.append(SMSector<Int>(lower: lower, upper: upper, value: i))
                upper = lower
            }
        }
        
        container.isUserInteractionEnabled = false
        addSubview(container)
        
        delegate.wheelDidChangeValue(to: currentSector)
    }
}
