//
//  ViewController.swift
//  SKPagerExample
//
//  Created by Sai Kallepalli on 01/02/23.
//

import UIKit
import SKPager
import SKBar
import EasyPeasy

class ViewController: UIViewController {
    
    let titles: [SKBarContentModel] = [
        SKBarContentModel(title: "This"),
        SKBarContentModel(title: "is"),
        SKBarContentModel(title: "an"),
        SKBarContentModel(title: "example"),
        SKBarContentModel(title: "of"),
        SKBarContentModel(title: "SKPager"),
    ]
    
    let colors: [UIColor] = [
        UIColor.red,
        UIColor.blue,
        UIColor.yellow,
        UIColor.green,
        UIColor.orange,
        UIColor.systemPink,
    ]
    
    var skPageControllers: [UIViewController] = []
    
    lazy var skBarEx1: SKBar = {
        let bar = SKBar(frame: .zero, theme: .title)
        bar.interItemSpacing = 20
        let selectedColor: UIColor = .black
        let unselectedColor: UIColor = .black.withAlphaComponent(0.4)
        bar.configuration = SKBarConfiguration(titleColor: unselectedColor,
                                               font: .systemFont(ofSize: 18),
                                               selectedTitleColor: selectedColor,
                                               selectedFont: .systemFont(ofSize: 18),
                                               highlightedTitleColor: .clear,
                                               indicatorColor: .black,
                                               separatorColor: .gray.withAlphaComponent(0.3))
        return bar
    }()
    
    let spacing: CGFloat = 20
    
    lazy var pageController: SKPager = {
        let pc = SKPager(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pc.dataSource = self
        pc.delegate   = self
        pc.pagerDelegate = self
        pc.view.backgroundColor = .gray
        return pc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(skBarEx1)
        skBarEx1.easy.layout(Top().to(view, .topMargin), Leading(), Trailing(), Height(50))
        skBarEx1.delegate = self
        skBarEx1.items = titles
        skBarEx1.setSelectedIndex(0)
        
        for color in colors {
            let vc1 = UIViewController()
            vc1.view.backgroundColor = color.withAlphaComponent(0.1)
            skPageControllers.append(vc1)
        }
        
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.view.easy.layout(Top().to(skBarEx1, .bottom),
                                        Leading(),
                                        Trailing(),
                                        Bottom().to(view, .bottom))
        
        pageController.didMove(toParent: self)
        if let firstVC = skPageControllers.first {
            pageController.setViewControllers([firstVC], direction: .forward, animated: false)
        }
    }
    
    var currentIndex: Int = 0
    var canMoveIndicator: Bool = true
}

extension ViewController: SKBarDelegate {
    func didSelectSKBarItemAt(_ skBar: SKBar, _ index: Int) {
        print("selected index", index)
        
        canMoveIndicator = false
        if index > currentIndex  {
            self.focusViewControllerAtIndex(index, direction: .forward)
        } else if index <  self.currentIndex {
            self.focusViewControllerAtIndex(index, direction: .reverse)
        }
    }
    
    private func focusViewControllerAtIndex(_ index: Int,
                                            direction: UIPageViewController.NavigationDirection) {
        
        guard let viewController = skPageControllers[safe: index] else {
            print("Index out of bound", index)
            return
        }
        
        // Add rtl support
        // direction.rtlDirection
        pageController.setViewControllers([viewController],
                                          direction: direction,
                                          animated: true) { [weak self] completed in
            guard let self = self else {
                return
            }
            if completed {
                self.currentIndex = index
                self.skBarEx1.setSelectedIndex(index)
                self.canMoveIndicator = true
            }
        }
    }
}

extension ViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = skPageControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return skPageControllers[index-1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard var index = skPageControllers.firstIndex(of: viewController) else {
            return nil
        }
        index = index + 1
        if index == skPageControllers.count {
            return nil
        }
        return skPageControllers[index]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers,
              let lastViewController = viewControllers.last,
              let index = skPageControllers.firstIndex(of: lastViewController) else {
            return
        }
        
        if finished {
            skBarEx1.setSelectedIndex(currentIndex)
            canMoveIndicator = true
        }
        
        if finished && completed {
            currentIndex = index
            skBarEx1.setSelectedIndex(currentIndex)
            canMoveIndicator = true
        }
    }
}

extension ViewController: SKPagerDelegate {
    func pagerTransitionPercentage(_ percentage: CGFloat, _ scrollDirection: ScrollDirection) {
        guard canMoveIndicator else {
            return
        }
        
        var toIndex: Int?
        switch scrollDirection {
            case .left:
                if currentIndex - 1 < 0 {
                    //                    print("Dont respond")
                } else {
                    //                    print("respond")
                    toIndex = currentIndex - 1
                }
            case .right:
                if currentIndex + 1 >= skPageControllers.count {
                    //                    print("Dont respond")
                } else {
                    //                    print("respond")
                    toIndex = currentIndex + 1
                }
        }
        print("percentage", percentage, "percentage > 0.0", percentage > 0.0, "scrollDirection", scrollDirection, "canMoveIndicator", canMoveIndicator, "currentIndex", currentIndex, "toIndex", toIndex)
        if let toIndex, percentage > 0.0 {
            skBarEx1.moveIndicator(forPercentage: percentage, from: currentIndex, to: toIndex)
        }
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
