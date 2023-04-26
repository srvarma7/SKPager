//
//  NewPagerVC.swift
//  SKPagerExample
//
//  Created by Sai Kallepalli on 26/04/23.
//

import UIKit
import EasyPeasy
import SKBar
import SKPager

class NewPagerVC: UIViewController {
    
    let titles: [SKBarContentModel] = [
        SKBarContentModel(title: "This"),
        SKBarContentModel(title: "is"),
        SKBarContentModel(title: "an"),
//        SKBarContentModel(title: "example"),
//        SKBarContentModel(title: "of"),
//        SKBarContentModel(title: "SKPager"),
    ]
    
    let colors: [UIColor] = [
        UIColor.red,
        UIColor.blue,
        UIColor.yellow,
//        UIColor.green,
//        UIColor.orange,
//        UIColor.systemPink,
    ]
    
    var skPageControllers: [UIViewController] = []
    
    lazy var skBarEx2: SKBar = {
        let config = SKBarConfiguration(titleColor: .black.withAlphaComponent(0.3),
                                        font: .systemFont(ofSize: 18),
                                        selectedTitleColor: .white,
                                        selectedFont: .systemFont(ofSize: 18),
                                        highlightedTitleColor: .systemBlue,
                                        indicatorColor: .systemBlue,
                                        separatorColor: .clear)
        
        
        let titleTheme: SKBarContentType = .title
        
        lazy var skBar = SKBar(frame: .zero, theme: titleTheme)
        
        let padding: CGFloat = 20
        skBar.contentInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        skBar.interItemSpacing = 4
        skBar.configuration = config
        skBar.indicatorStyle = .capsule
        skBar.indicatorCornerRadius = 20
        skBar.minimumItemWidth = 40
        skBar.delegate = self
        return skBar
    }()
    
    lazy var skPager: SKScrollPager = {
        let pc = SKScrollPager(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 200), dataSource: self)
        pc.backgroundColor = .gray
        return pc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(skBarEx2)
        skBarEx2.easy.layout(Top().to(view, .topMargin), Leading(), Trailing(), Height(50))
        skBarEx2.items = titles
        skBarEx2.setSelectedIndex(0)
        
        for color in colors {
            let vc1 = UIViewController()
            vc1.view.backgroundColor = color.withAlphaComponent(0.5)
            skPageControllers.append(vc1)
        }
        
        view.addSubview(skPager)
        skPager.easy.layout(Top(10).to(skBarEx2, .bottom),
                                   Leading(),
                                   Trailing(),
                                   Height(500))
        
        skPager.reloadPages()
    }
    
    var currentIndex: Int = 0
    var canMoveIndicator: Bool = true
}

extension NewPagerVC: SKScrollPagerDatasource {
    func skPagerScrollInProgress(from: Int, to: Int, percentage: CGFloat) {
        
    }
    
    func skPagerScrolledToPageIndex(_ index: Int) {
        skBarEx2.setSelectedIndex(index)
    }
    
    func skPagerViewControllers() -> [UIViewController] {
        return skPageControllers
    }
}

extension NewPagerVC: SKBarDelegate {
    func didSelectSKBarItemAt(_ skBar: SKBar, _ index: Int) {
        skPager.moveToPage(index: index)
    }
}

//import SwiftUI
//
//struct Previewer: PreviewProvider {
//    static var previews: some SwiftUI.View {
//        let devices = [
////            "iPhone 5S",
//            "iPhone 11"
//        ]
//
//        Group {
//            ForEach(devices, id: \.self) { name in
//                NewPagerVC()
//                    .preview
//                    .previewDevice(PreviewDevice(rawValue: name))
//                    .previewDisplayName(name)
//            }
//        }
//    }
//}
