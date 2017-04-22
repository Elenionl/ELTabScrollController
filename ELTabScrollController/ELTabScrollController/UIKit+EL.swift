/*
 **The MIT License**
 **Copyright © 2017 Hanping Xu**
 **All rights reserved.**
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
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
