//
//  HomeController.swift
//  ELTabScrollController
//
//  Created by Elenion on 2017/5/5.
//  Copyright © 2017年 Elenion. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
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
    
    lazy var unequalUnscrollable: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Unequal Unscrollable", for: .normal)
        view.tag = 2
        view.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        view.setTitleColor(.blue, for: .normal)
        return view
    }()
    
    lazy var unequalScrollable: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Unequal Scrollable", for: .normal)
        view.tag = 3
        view.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        view.setTitleColor(.blue, for: .normal)
        return view
    }()
    
    func didTapButton(_ button: UIButton) {
        switch button.tag {
        case 0:
            let ctrl = EUTabScrollController()
            navigationController?.pushViewController(ctrl, animated: true)
        case 1:
            let ctrl = ESTabScrollController()
            navigationController?.pushViewController(ctrl, animated: true)
        case 2:
            let ctrl = UUTabScrollController()
            navigationController?.pushViewController(ctrl, animated: true)
        case 3:
            let ctrl = USTabScrollController()
            navigationController?.pushViewController(ctrl, animated: true)
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(equalUnscrollable)
        view.addSubview(equalScrollable)
        view.addSubview(unequalUnscrollable)
        view.addSubview(unequalScrollable)
        
        equalUnscrollable.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        equalScrollable.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(60)
        }
        unequalUnscrollable.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(100)
        }
        unequalScrollable.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(140)
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
