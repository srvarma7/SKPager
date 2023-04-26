//
//  SKScrollPager.swift
//  
//
//  Created by Sai Kallepalli on 26/04/23.
//

import UIKit

//public typealias SKPagerDelegatable = SKScrollPagerDelegate & UIViewController

public protocol SKScrollPagerDatasource: AnyObject {
    func skPagerViewControllers() -> [UIViewController]
    func skPagerScrolledToPageIndex(_ index: Int)
    func skPagerScrollInProgress(from: Int, to: Int, percentage: CGFloat)
}

public class SKScrollPager: UIScrollView {
    
    var currentPageCount: Int = 0
    var currentPageIndex: Int = 0
    
    public weak var dataSource: SKScrollPagerDatasource?
    
    public init(frame: CGRect, dataSource: SKScrollPagerDatasource) {
        super.init(frame: frame)
        
        self.dataSource = dataSource
        
        backgroundColor = .yellow
        isPagingEnabled = true
        bounces = true
        delegate = self
        showsHorizontalScrollIndicator = false
        loadPager()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadPager(selectedIndex: Int = 0, animated: Bool = true) {
        if let pages = dataSource?.skPagerViewControllers() {
            currentPageCount = pages.count
            for (index, vc) in pages.enumerated() {
                addSubview(vc.view)
                vc.view.frame = CGRect(x: CGFloat(index) * bounds.width, y: 0, width: bounds.width, height: bounds.height)
            }
            
            contentSize = CGSize(width: CGFloat(pages.count) * bounds.width, height: 0)
            
            moveToPage(index: selectedIndex, animated: animated)
        }
    }
    
    public func moveToPage(index: Int, animated: Bool = true) {
        let scrollViewWidth = frame.width
        let contentOffsetX = scrollViewWidth * CGFloat(index)
        if contentOffset.x != contentOffsetX {
            setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: animated)
            lastXOffset = contentOffsetX
        }
        currentPageIndex = index
    }
    
    private func getCurrentIndex() -> Int {
        return Int(floor(contentOffset.x / frame.width))
    }
    
    var lastXOffset: CGFloat = .zero
    var isMovingToNextPage: Bool?
}

extension SKScrollPager {
    public func reloadPages(selectedIndex: Int = 0) {
        subviews.forEach({ $0.removeFromSuperview() })
        
        loadPager(selectedIndex: selectedIndex)
    }
}

extension SKScrollPager: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("\(lastXOffset) < \(scrollView.contentOffset.x)")
        
        if isMovingToNextPage == nil {
            isMovingToNextPage = scrollView.contentOffset.x >= lastXOffset
        }
        
        let contentOffset = scrollView.contentOffset
        print("contentOffset", contentOffset)
        
//        abs(contentOffset.x - view.frame.size.width) / view.frame.size.width
        
        let scrollPercentage = (scrollView.contentOffset.x) / (scrollView.bounds.width)
        print("scrollPercentage:", scrollPercentage, ", from:", currentPageIndex, ", to:", isMovingToNextPage == true ? currentPageIndex + 1 : currentPageIndex - 1, ",isMovingToNextPage", isMovingToNextPage) // scrollPercentage 0.4996124031007752
        
//        percentage 0.9992248062015503 percentage > 0.0 true scrollDirection right canMoveIndicator true currentIndex 0 toIndex Optional(1)

//        pagerDelegate?.pagerTransitionPercentage(percentComplete, scrollDirection)
        
        lastXOffset = scrollView.contentOffset.x
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("will \(lastXOffset) < \(scrollView.contentOffset.x)")
        
//        if isMovingToNextPage == nil {
//            isMovingToNextPage = lastXOffset < scrollView.contentOffset.x
//        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = getCurrentIndex()
        currentPageIndex = currentPage
        dataSource?.skPagerScrolledToPageIndex(currentPage)
        
        isMovingToNextPage = nil
    }
}
