//
//  BottomPopupUtils.swift
//  BottomPopup
//
//  Created by Yichen Yao on 04.04.2019.
//  Copyright © 2018 Yichen Yao. All rights reserved.
//

import UIKit

typealias BottomPresentableViewController = BottomPopupAttributesDelegate & UIViewController

public protocol BottomPopupDelegate: class {
    func bottomPopupViewLoaded()
    func bottomPopupWillAppear()
    func bottomPopupDidAppear()
    func bottomPopupWillDismiss()
    func bottomPopupDidDismiss()
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat)
}

public extension BottomPopupDelegate {
    func bottomPopupViewLoaded() { }
    func bottomPopupWillAppear() { }
    func bottomPopupDidAppear() { }
    func bottomPopupWillDismiss() { }
    func bottomPopupDidDismiss() { }
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) { }
}

public protocol BottomPopupAttributesDelegate: class {
    func getPopupHeight() -> CGFloat
    func getPopupTopCornerRadius() -> CGFloat
    func getPopupPresentDuration() -> Double
    func getPopupDismissDuration() -> Double
    func shouldPopupDismissInteractivelty() -> Bool
    func getDimmingViewAlpha() -> CGFloat
}

public struct BottomPopupConstants {
    static let kDefaultHeight: CGFloat = 600.0
    static let kDefaultTopCornerRadius: CGFloat = 10.0
    static let kDefaultPresentDuration = 0.5
    static let kDefaultDismissDuration = 0.5
    static let dismissInteractively = true
    static let kDimmingViewDefaultAlphaValue: CGFloat = 0.5
}
