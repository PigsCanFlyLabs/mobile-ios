//
//  UIKit+Helpers.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 04.03.2022.
//

import UIKit

extension UINavigationController {

  open override func viewWillLayoutSubviews() {
      navigationBar.topItem?.backButtonDisplayMode = .minimal
      navigationItem.largeTitleDisplayMode = .never
      setNavigationBarHidden(true, animated: false)
  }

}

// Restore swipe gesture in `NavigationView` when it is hidden
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
