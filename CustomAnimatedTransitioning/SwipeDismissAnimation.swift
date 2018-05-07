//
//  SwipeDismissAnimation.swift
//  CustomAnimatedTransitioning
//
//  Created by Hao Lee on 2018/5/6.
//  Copyright © 2018年 Hao Lee. All rights reserved.
//

import UIKit

class SwipeDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    // 過場動畫執行時間
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    // 過場動畫
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }
        let fromView = fromViewController.view!

        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        let toView = toViewController.view!

        let screenBounds = UIScreen.main.bounds
        let initFrame = transitionContext.initialFrame(for: fromViewController)
        let finalFrame = initFrame.offsetBy(dx: 0, dy: screenBounds.size.height)

        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, belowSubview: fromView)

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            fromView.frame = finalFrame
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
