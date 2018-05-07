//
//  DraggingDownInteractiveTransition.swift
//  CustomAnimatedTransitioning
//
//  Created by Hao Lee on 2018/5/6.
//  Copyright © 2018年 Hao Lee. All rights reserved.
//

import UIKit

class DraggingDownInteractiveTransition: UIPercentDrivenInteractiveTransition {

    var shouldComplete = false
    var presentingVC: UIViewController?

    func wire(to viewController: UIViewController, otherViews: [UIView] = []) {
        self.presentingVC = viewController
        self.prepareGestureRecognizer(in: viewController.view)
        for view in otherViews {
            self.prepareGestureRecognizer(in: view)
        }
    }

    func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(gesture)
    }

    override var completionSpeed: CGFloat {
        get {
            return 1 - self.percentComplete
        }
        set {
            super.completionSpeed = newValue
        }
    }

    var firstLocation = CGPoint.zero
    var runwayLength: CGFloat = 0

    @objc
    func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let presentingVC = self.presentingVC else {
            return
        }

        let displacement = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)

        switch gestureRecognizer.state {
        case .began:
            self.firstLocation = displacement
            if let navigationController = presentingVC as? ScrollViewProtocol {
                if gestureRecognizer.view == presentingVC.view {
                    self.runwayLength = navigationController.contentOffsetY
                } else {
                    self.runwayLength = 0
                }
            }
            presentingVC.dismiss(animated: true)
        case .changed:
            var percent = (displacement.y - self.firstLocation.y - self.runwayLength) / UIScreen.main.bounds.height
            percent = fmin(fmax(percent, 0), 1)
            self.shouldComplete = percent > 0.5

            self.update(percent)
        case .ended, .cancelled:
            if !self.shouldComplete || gestureRecognizer.state == .cancelled {
                self.cancel()
            } else {
                self.finish()
            }
        default:
            break
        }
    }
}
