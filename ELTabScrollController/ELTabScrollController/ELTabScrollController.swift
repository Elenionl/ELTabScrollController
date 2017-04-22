import UIKit
import SnapKit

public enum ELTabScrollSwitchTriggerType {
    case buttonTap
    case scroll
}

public enum ELTabBarType {
    case equal_unscrollable
//    case equal_scrollable
//    case accordingToContent_unscrollable
//    case accordingToContent_scrollable
}

public typealias ELSwitchHandler = (_ index: Int, _ triggerType: ELTabScrollSwitchTriggerType) -> Void

open class ELTabScrollController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - UI
    open lazy var tab: UIScrollView = {
        let scroll = UIScrollView(frame: .null)
        return scroll
    }()
    
    open lazy var tabStackView: UIStackView = {
        let stack = UIStackView(frame: .null)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    open lazy var sliderBackgroundView: UIView = {
        let view = UIView(frame: .null)
        return view
    }()
    
    open lazy var sliderView: UIView = {
        let view = UIView(frame: .null)
        return view
    }()
    
    open lazy var container: UIScrollView = {
        let scroll = UIScrollView(frame: .null)
        scroll.isPagingEnabled = true
        scroll.delegate = self
        return scroll
    }()
    
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
    
    // MARK: - Settings
    
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
    
    open var width: CGFloat! = UIScreen.main.bounds.size.width
    
    open var switchHandler: ELSwitchHandler?
    
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
    
    public convenience init() {
        self.init(width: nil, type: nil)
    }
    
    public init(width: CGFloat?, type: ELTabBarType?) {
        super.init(nibName: nil, bundle: nil)
        defer {
            self.width = width ?? UIScreen.main.bounds.size.width
            self.tabBarType = type ?? .equal_unscrollable
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
    
    open var tabBarType: ELTabBarType! = ELTabBarType.equal_unscrollable {
        didSet {
            tabStackView.snp.updateConstraints { (make) in
                make.width.equalTo(width)
            }
            tabStackView.distribution = .fillEqually
        }
    }
    
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
    }
}

open class ELTabScrollItem {
    open var title: String?
    open var image: UIImage?
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
    
    open lazy var view: UIView = {
        let view = self.viewController.view
        return view!
    }()
    open var viewController: UIViewController
    
    public init(title: String?, image: UIImage?, viewController: UIViewController, view: UIView?) {
        self.title = title
        self.image = image
        self.viewController = viewController
        if let newView = view {
            self.view = newView
        }
    }
    
    public init(button: UIButton, viewController: UIViewController, view: UIView?) {
        self.viewController = viewController
        if let newView = view {
            self.view = newView
        }
        self.button = button
    }
}
