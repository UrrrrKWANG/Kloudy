//
//  UINavigationController+.swift
//  Kloudy
//
//  Created by Hyeongjung on 2022/12/09.
//

import UIKit
import Foundation

// https://github.com/PLREQ/PLREQ/blob/develop/PLREQ/PLREQ/Extensions/UINavigationController%2B.swift

// NavigationView는 Swipe를 통한 뒤로가기 기능을 기본적으로 제공하는데, NavigationBar를 숨기게 되면 Swipe를 통한 뒤로가기 기능을 사용할 수 없으므로 extension을 통해 제스처를 통한 뒤로가기 기능 추가
extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
}
