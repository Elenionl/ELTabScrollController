//
//  UIKit+EL.swift
//  ELTabScrollController
//
//  Created by Elenion on 2017/4/22.
//  Copyright © 2017年 Elenion. All rights reserved.
//

import UIKit

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

enum CGRectAlignmentType {
    case left
    case right
    case top
    case bottom
    case center
}

extension CGRect {
    static func set(width: CGFloat, forView view: UIView, alignment: CGRectAlignmentType) {
        var x: CGFloat
        switch alignment {
        case .left:
            x = view.frame.origin.x
        case .right:
            x = view.frame.origin.x + view.frame.size.width - width
        default :
            x = view.frame.origin.x + (view.frame.size.width - width)/2
        }
        view.frame = CGRect(x: x, y: view.frame.origin.y, width: width, height: view.frame.size.height)
    }
    static func set(height: CGFloat, forView view: UIView, alignment: CGRectAlignmentType) {
        var y: CGFloat
        switch alignment {
        case .top:
            y = view.frame.origin.y
        case .bottom:
            y = view.frame.origin.y + view.frame.size.height - height
        default :
            y = view.frame.origin.y + (view.frame.size.height - height)/2
        }
        view.frame = CGRect(x: view.frame.origin.x, y: y, width: view.frame.size.width, height: height)
    }
}

extension UIButton {
    func setSelectedIfNot(_ selected: Bool) {
        if self.isSelected != selected {
            self.isSelected = selected
        }
    }
}
