//
//  SKPager.swift
//  SKBarExample
//
//  Created by Sai Kallepalli on 01/02/23.
//

import UIKit
import SKBar
import EasyPeasy

public enum ScrollDirection {
    case left, right
}

public protocol SKPagerDelegate: AnyObject {
    func pagerTransitionPercentage(_ percentage: CGFloat, _ scrollDirection: ScrollDirection)
}

public class SKPager: UIPageViewController {
    private var lastContentOffset: CGPoint = .zero
    
    public weak var pagerDelegate: SKPagerDelegate?
    
    public var scrollView: UIScrollView?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        for subview in view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
                self.scrollView = scrollView
                break
            }
        }
    }
    
    
}

extension SKPager: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Future usage
        /// to move the main tab view underline along with scroll percentage.
        let contentOffset = scrollView.contentOffset
        
        var scrollDirection: ScrollDirection = .right
        if (lastContentOffset.x > scrollView.contentOffset.x) {
            scrollDirection = .left
        }
        else if (lastContentOffset.x < scrollView.contentOffset.x) {
            scrollDirection = .right
        }
        lastContentOffset = scrollView.contentOffset
        
        var percentComplete: CGFloat
        percentComplete = abs(contentOffset.x - view.frame.size.width) / view.frame.size.width
        
        //        if contentOffset.x < 0 {
        //            return
        //        }
        
        pagerDelegate?.pagerTransitionPercentage(percentComplete, scrollDirection)
    }
}
