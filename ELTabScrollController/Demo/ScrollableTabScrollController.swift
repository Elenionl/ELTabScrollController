/*
 **The MIT License**
 **Copyright © 2017 Hanping Xu**
 **All rights reserved.**
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit

class ScrollableTabScrollController: ELTabScrollController {
    // MARK: - LifeCircle
    init() {
        super.init(type: .equal_scrollable)
        let ctrl1 = ViewController(nibName: nil, bundle: nil)
        let ctrl2 = ViewController(nibName: nil, bundle: nil)
        let ctrl3 = ViewController(nibName: nil, bundle: nil)
        let ctrl4 = ViewController(nibName: nil, bundle: nil)
        let item1 = ELTabScrollItem(title: "Tab 1 View Controller", image: nil, viewController: ctrl1, view: ctrl1.tableView)
        let item2 = ELTabScrollItem(title: "Tab 2 View Controller", image: nil, viewController: ctrl2, view: ctrl2.tableView)
        let item3 = ELTabScrollItem(title: "Tab 3 View Controller", image: nil, viewController: ctrl3, view: ctrl3.tableView)
        let item4 = ELTabScrollItem(title: "Tab 4 View Controller", image: nil, viewController: ctrl4, view: ctrl4.tableView)
        items = [item1, item2, item3, item4]
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Equal Scrollable"
        tab.backgroundColor = UIColor.orange
        sliderView.backgroundColor = .white
        container.backgroundColor = UIColor.lightGray
        tabButtonHeight = 66
        sliderViewHeight = 10
        buttonFont = UIFont.boldSystemFont(ofSize: 18)
        buttonSelectedTitleColor = UIColor.white
        buttonNormalTitleColor = UIColor.lightGray
        switchHandler = { (index, type) in
            print(index, type)
        }
    }
}
