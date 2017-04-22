//
//  TabScrollViewController.swift
//  ELTabScrollController
//
//  Created by Elenion on 2017/4/22.
//  Copyright © 2017年 Elenion. All rights reserved.
//

import UIKit

class TabScrollController: ELTabScrollController {
    // MARK: - LifeCircle
    init() {
        super.init(width: nil, type: nil)
        let ctrl1 = ViewController(nibName: nil, bundle: nil)
        let ctrl2 = ViewController(nibName: nil, bundle: nil)
        let ctrl3 = ViewController(nibName: nil, bundle: nil)
        let ctrl4 = ViewController(nibName: nil, bundle: nil)
        let item1 = ELTabScrollItem(title: "Tab 1", image: nil, viewController: ctrl1, view: ctrl1.tableView)
        let item2 = ELTabScrollItem(title: "Tab 2", image: nil, viewController: ctrl2, view: ctrl2.tableView)
        let item3 = ELTabScrollItem(title: "Tab 3", image: nil, viewController: ctrl3, view: ctrl3.tableView)
        let item4 = ELTabScrollItem(title: "Tab 4", image: nil, viewController: ctrl4, view: ctrl4.tableView)
        items = [item1, item2, item3, item4]
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.title = "Demo"
        super.viewDidLoad()
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
