/*
 **The MIT License**
 **Copyright © 2017 Hanping Xu**
 **All rights reserved.**
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit
import SnapKit

public enum ELTabScrollSwitchTriggerType {
    case buttonTap
    case scroll
}

public enum ELTabBarType {
    case equal_unscrollable
    case equal_scrollable
//    case accordingToContent_unscrollable
//    case accordingToContent_scrollable
}

public typealias ELSwitchHandler = (_ index: Int, _ triggerType: ELTabScrollSwitchTriggerType) -> Void

open class ELTabScrollController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - UI
    /// Tab including Buttons and Slider
    open lazy var tab: UIScrollView = {
        let scroll = UIScrollView(frame: .null)
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    /// This stackView holds buttons
    open lazy var tabStackView: UIStackView = {
        let stack = UIStackView(frame: .null)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    /// Background of slider
    open lazy var sliderBackgroundView: UIView = {
        let view = UIView(frame: .null)
        return view
    }()
    
    /// Slider
    open lazy var sliderView: UIView = {
        let view = UIView(frame: .null)
        return view
    }()
    
    /// A scrollView containing a stackView of viewControllers
    open lazy var container: UIScrollView = {
        let scroll = UIScrollView(frame: .null)
        scroll.isPagingEnabled = true
        scroll.delegate = self
        return scroll
    }()
    
    /// A stackView containing views of viewControllers
    open lazy var containerStackView: UIStackView = {
        let stack = UIStackView(frame: .null)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    // MARK: - Flags
    
    var isViewDidLoadExecuted = false
    var itemsSettingHandler: (() -> Void)?
    var typeSettingHandler: (() -> Void)?
    // MARK: - Settings
    
    /// Items containing buttons and viewControllers
    open var items: [ELTabScrollItem]! = [] {
        didSet {
            itemsSettingHandler = { [weak self] Void in
                if let strongSelf = self {
                    _ = oldValue.map { (item) -> ELTabScrollItem in
                        strongSelf.tabStackView.removeArrangedSubview(item.button)
                        item.view.snp.removeConstraints()
                        item.view.removeFromSuperview()
                        item.viewController.removeFromParentViewController()
                        return item
                    }
                    strongSelf.containerStackView.snp.remakeConstraints({ (make) in
                        make.width.equalTo(CGFloat(strongSelf.items.count) * strongSelf.width)
                        make.height.equalTo(strongSelf.container.snp.height)
                        make.edges.equalToSuperview()
                    })
                    for itemGroup in strongSelf.items.enumerated() {
                        strongSelf.tabStackView.addArrangedSubview(itemGroup.element.button)
                        itemGroup.element.button.tag = itemGroup.offset
                        itemGroup.element.button.addTarget(strongSelf, action: #selector(strongSelf.didTapTabButton(_:)), for: .touchUpInside)
                        strongSelf.addChildViewController(itemGroup.element.viewController)
                        strongSelf.containerStackView.addArrangedSubview(itemGroup.element.view)
                        itemGroup.element.view.snp.remakeConstraints({ (make) in
                            make.width.equalTo(strongSelf.width)
                            make.height.equalTo(strongSelf.container.snp.height)
                        })
                    }
                    strongSelf.setCurrentIndex(strongSelf._currentIndex, animated: false)
                }
            }
            if isViewDidLoadExecuted && (itemsSettingHandler != nil) {
                itemsSettingHandler?()
                itemsSettingHandler = nil
            }
        }
    }
    
    /// The width of the base view. Default value is screen width
    open var width: CGFloat! = UIScreen.main.bounds.size.width
    
    /// Triggered by switch behavior
    open var switchHandler: ELSwitchHandler?
    
    /// Height of button
    open var tabButtonHeight: CGFloat = 44 {
        didSet {
            tabStackView.snp.updateConstraints { (make) in
                make.height.equalTo(tabButtonHeight)
            }
            tab.snp.updateConstraints { (make) in
                make.height.equalTo(tabButtonHeight + sliderViewHeight)
            }
        }
    }
    
    /// Hight of slider
    open var sliderViewHeight: CGFloat = 5 {
        didSet {
            sliderBackgroundView.snp.updateConstraints { (make) in
                make.height.equalTo(sliderViewHeight)
            }
            CGRect.set(height: sliderViewHeight, forView: sliderView, alignment: CGRectAlignmentType.top)
            tab.snp.updateConstraints { (make) in
                make.height.equalTo(tabButtonHeight + sliderViewHeight)
            }
            tab.layoutIfNeeded()
        }
    }
    
    /// Font of button
    open var buttonFont: UIFont? {
        didSet {
            if let font = buttonFont {
                for itemGroup in items.enumerated() {
                    itemGroup.element.button.titleLabel?.font = font
                }
            }
        }
    }
    
    open var buttonSelectedBackgroudColor: UIColor? {
        didSet {
            if let color = buttonSelectedBackgroudColor {
                for itemGroup in items.enumerated() {
                    itemGroup.element.button.setBackgroundImage(UIImage.from(color: color), for: .selected)
                }
            }
        }
    }
    
    open var buttonNormalBackgroudColor: UIColor? {
        didSet {
            if let color = buttonNormalBackgroudColor {
                for itemGroup in items.enumerated() {
                    itemGroup.element.button.setBackgroundImage(UIImage.from(color: color), for: .normal)
                }
            }
        }
    }
    
    open var buttonSelectedTitleColor: UIColor? {
        didSet {
            if let color = buttonSelectedTitleColor {
                for itemGroup in items.enumerated() {
                    itemGroup.element.button.setTitleColor(color, for: .selected)
                }
            }
        }
    }
    
    open var buttonNormalTitleColor: UIColor? {
        didSet {
            if let color = buttonNormalTitleColor {
                for itemGroup in items.enumerated() {
                    itemGroup.element.button.setTitleColor(color, for: .normal)
                }
            }
        }
    }
    
    // MARK: - LifeCircle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupFrame()
        if (itemsSettingHandler != nil) {
            itemsSettingHandler?()
            itemsSettingHandler = nil
        }
        if (typeSettingHandler != nil) {
            typeSettingHandler?()
            typeSettingHandler = nil
        }
        isViewDidLoadExecuted = true
    }

    open func setupViews() {
        view.addSubview(tab)
        tab.addSubview(tabStackView)
        tab.addSubview(sliderBackgroundView)
        sliderBackgroundView.addSubview(sliderView)
        view.addSubview(container)
        container.addSubview(containerStackView)
    }
    
    open func setupFrame() {
        tab.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(tabButtonHeight + sliderViewHeight)
        }
        container.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(tab.snp.bottom)
        }
        containerStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tabStackView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(tabButtonHeight)
            make.width.equalTo(width)
        }
        sliderBackgroundView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(tabStackView.snp.bottom)
            make.height.equalTo(sliderViewHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    public init(width: CGFloat = UIScreen.main.bounds.size.width, type: ELTabBarType = ELTabBarType.equal_unscrollable) {
        super.init(nibName: nil, bundle: nil)
        defer {
            self.width = width
            self.tabBarType = type
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Delegate
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setSliderPosition(scrollView.contentOffset.x)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index =  items.filter { (item) -> Bool in
            return item.button.isSelected
        }.map({ (chosen) -> Int in
            chosen.button.tag
        })
        if let switchHandlerSure = switchHandler {
            switchHandlerSure(index[0], .scroll)
        }
    }
    
    // MARK: - Operate
    
    /// Set the current index
    ///
    /// - Parameters:
    ///   - index: index
    ///   - animated: animated
    open func setCurrentIndex(_ index: Int, animated: Bool) {
        tabStackView.layoutIfNeeded()
        let point = CGPoint(x: width * CGFloat(items[index].button.tag), y: 0)
        if point == container.contentOffset {
            setSliderPosition(point.x)
        }
        else {
            self.container.setContentOffset(point, animated: animated)
        }
        _currentIndex = index
    }
    
    private var _currentIndex: Int = 0
    
    open func didTapTabButton(_ button: UIButton) {
        setCurrentIndex(button.tag, animated: true)
        if let handler = switchHandler {
            handler (button.tag, .buttonTap)
        }
    }
    
    open var tabBarType: ELTabBarType = ELTabBarType.equal_unscrollable {
        didSet {
            typeSettingHandler = { [weak self] in
                if let strongSelf = self {
                    switch strongSelf.tabBarType {
                    case .equal_unscrollable:
                        strongSelf.tabStackView.snp.remakeConstraints { (make) in
                            make.left.top.right.equalTo(strongSelf.tab)
                            make.height.equalTo(strongSelf.tabButtonHeight)
                            make.width.equalTo(strongSelf.width)
                        }
                        strongSelf.tabStackView.distribution = .fillEqually
                    case .equal_scrollable:
                        var buttonWidth: CGFloat = 0.0
                        for item in strongSelf.items {
                            item.button.sizeToFit()
                            if item.button.frame.width > buttonWidth {
                                buttonWidth = item.button.frame.width
                            }
                        }
                        buttonWidth += 30
                        strongSelf.tabStackView.snp.remakeConstraints { (make) in
                            make.left.top.right.equalTo(strongSelf.tab)
                            make.height.equalTo(strongSelf.tabButtonHeight)
                            make.width.equalTo(buttonWidth * CGFloat(strongSelf.items.count))
                        }
                        strongSelf.tabStackView.distribution = .fillEqually
                    }
                    strongSelf.setCurrentIndex(strongSelf._currentIndex, animated: false)
                }
            }
            if isViewDidLoadExecuted && (typeSettingHandler != nil) {
                typeSettingHandler?()
                typeSettingHandler = nil
            }
        }
    }
    
    /// An inner function mostly used to calculate the frame of slider
    ///
    /// - Parameter position: Offset of container
    open func setSliderPosition(_ position: CGFloat)  {
        let totalWidth = container.contentSize.width
        var currentLeftScreen: Int
        var currentRightScreen: Int
        var distanceFromLeftScreen: CGFloat
        if position <= 0 {
            currentLeftScreen = -1
            currentRightScreen = currentLeftScreen + 1
            distanceFromLeftScreen = width + position
        }
        else if position > totalWidth {
            currentLeftScreen = items.count - 1
            currentRightScreen = currentLeftScreen + 1
            distanceFromLeftScreen = position - totalWidth
        }
        else {
            currentLeftScreen = Int(position/width)
            currentRightScreen = currentLeftScreen + 1
            distanceFromLeftScreen = position - width * CGFloat(currentLeftScreen)
        }
        let percentage: CGFloat = distanceFromLeftScreen/width
        var leftWidth: CGFloat
        var rightWidth: CGFloat
        var centerPosition: CGFloat
        var sliderWidth: CGFloat
        
        if currentLeftScreen < 0 {
            leftWidth = (items.first?.button.frame.width)!
            rightWidth = (items.first?.button.frame.width)!
            sliderWidth = (leftWidth * (1 - percentage)) + (rightWidth * percentage)
            centerPosition = (items.first?.button.center.x)! - leftWidth + percentage * leftWidth
            for itemGroup in items.enumerated() {
                itemGroup.element.button.setSelectedIfNot(itemGroup.offset == 0)
            }
        }
        else if currentRightScreen >= items.count {
            leftWidth = (items.last?.button.frame.width)!
            rightWidth = (items.last?.button.frame.width)!
            sliderWidth  = (leftWidth * (1 - percentage)) + (rightWidth * percentage)
            centerPosition = (items.last?.button.center.x)! + percentage * leftWidth
            for itemGroup in items.enumerated() {
                itemGroup.element.button.setSelectedIfNot(itemGroup.offset == items.count - 1)
            }
        }
        else {
            leftWidth = items[currentLeftScreen].button.frame.width
            rightWidth = items[currentRightScreen].button.frame.width
            sliderWidth  = (leftWidth * (1 - percentage)) + (rightWidth * percentage)
            centerPosition = (items[currentLeftScreen].button.center.x) + percentage * (leftWidth + rightWidth)/2
            if (percentage * (leftWidth + rightWidth)/2) < leftWidth/2 {
                for itemGroup in items.enumerated() {
                    itemGroup.element.button.setSelectedIfNot(itemGroup.offset == currentLeftScreen)
                }
            }
            if (percentage * (leftWidth + rightWidth)/2) > leftWidth/2 {
                for itemGroup in items.enumerated() {
                    itemGroup.element.button.setSelectedIfNot(itemGroup.offset == currentRightScreen)
                }
            }
        }
        sliderView.center.x = centerPosition
        sliderView.frame.origin.y = 0
        CGRect.set(width: sliderWidth, forView: sliderView, alignment: .center)
        CGRect.set(height: sliderViewHeight, forView: sliderView, alignment: .top)
        if (sliderView.frame.origin.x - tab.contentOffset.x) < 0 {
            let offset = sliderView.frame.origin.x < 0 ? 0 : sliderView.frame.origin.x
            tab.setContentOffset(CGPoint(x: offset, y: 0), animated: false)
        }
        if (sliderView.frame.origin.x + sliderView.frame.width - tab.contentOffset.x) > self.width {
            let offset = sliderView.frame.origin.x + sliderView.frame.width > tab.contentSize.width ? (tab.contentSize.width - self.width) : (sliderView.frame.origin.x + sliderView.frame.width - self.width)
            tab.setContentOffset(CGPoint(x: offset, y: 0), animated: false)
        }
    }
}

/// Item
open class ELTabScrollItem {
    /// Title of Button
    open var title: String?
    /// Image of Button
    open var image: UIImage?
    /// If setted, will override title and image
    open lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.brown, for: .normal)
        button.setTitleColor(.black, for: .selected)
        if let buttonTitle = self.title {
            button.setTitle(buttonTitle, for: .normal)
        }
        if let buttonImage = self.image {
            button.setImage(buttonImage, for: .normal)
        }
        return button
    }()
    
    /// Which view will be presented, should be the subView of viewController.view
    open lazy var view: UIView = {
        let view = self.viewController.view
        return view!
    }()
    /// The child viewController
    open var viewController: UIViewController
    
    /// Item including button and viewController
    ///
    /// - Parameters:
    ///   - title: Title of button
    ///   - image: Image of button
    ///   - viewController: Child viewController
    ///   - view: The showing view
    public init(title: String?, image: UIImage?, viewController: UIViewController, view: UIView?) {
        self.title = title
        self.image = image
        self.viewController = viewController
        if let newView = view {
            self.view = newView
        }
    }
    
    /// Item including button and viewController
    ///
    /// - Parameters:
    ///   - button: The custom button
    ///   - viewController: Child viewController
    ///   - view: The showing view
    public init(button: UIButton, viewController: UIViewController, view: UIView?) {
        self.viewController = viewController
        if let newView = view {
            self.view = newView
        }
        self.button = button
    }
}
