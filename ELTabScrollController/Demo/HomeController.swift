//
//  HomeController.swift
//  ELTabScrollController
//
//  Created by Elenion on 2017/5/5.
//  Copyright © 2017年 Elenion. All rights reserved.
//

import UIKit

class HomeController: ViewController {
    lazy var equalUnscrollable: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Equal Unscrollable", for: .normal)
        view.tag = 0
        view.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        view.setTitleColor(.blue, for: .normal)
        return view
    }()
    lazy var equalScrollable: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Equal Scrollable", for: .normal)
        view.tag = 1
        view.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        view.setTitleColor(.blue, for: .normal)
        return view
    }()
    
    func didTapButton(_ button: UIButton) {
        switch button.tag {
        case 0:
            let ctrl = UnscrollableTabScrollController()
            navigationController?.pushViewController(ctrl, animated: true)
        case 1:
            let ctrl = ScrollableTabScrollController()
            navigationController?.pushViewController(ctrl, animated: true)
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(equalUnscrollable)
        view.addSubview(equalScrollable)
        
        equalUnscrollable.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        equalScrollable.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(60)
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
