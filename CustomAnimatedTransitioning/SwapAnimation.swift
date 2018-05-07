//
//  SwapAnimation.swift
//  CustomAnimatedTransitioning
//
//  Created by Hao Lee on 2018/5/4.
//  Copyright © 2018年 Hao Lee. All rights reserved.
//

import UIKit

class SwapAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    enum MovementType {
        case clockwise
        case counterclockwise
    }

    var movementType: MovementType = .clockwise

    // 過場動畫執行時間
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }

    // 過場動畫
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewController(forKey: .from)?.view else {
            return
        }

        guard let toView = transitionContext.viewController(forKey: .to)?.view else {
            return
        }

        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, belowSubview: fromView)

        self.movesAnimation(using: transitionContext, fromView: fromView, toView: toView)

        self.zoomAnimation(using: transitionContext, fromView: fromView, toView: toView)
    }

    // 兩畫面向兩側跑
    func movesAnimation(using transitionContext: UIViewControllerContextTransitioning,
                        fromView: UIView,
                        toView: UIView) {
        let duration = self.transitionDuration(using: transitionContext) / 2

        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock {
            transitionContext.completeTransition(true)
        }

        let fromOfPositionAnimation = CABasicAnimation(keyPath: "position.x")
        switch self.movementType {
        case .clockwise:
            fromOfPositionAnimation.toValue = 0
        case .counterclockwise:
            fromOfPositionAnimation.toValue = fromView.frame.width
        }
        fromOfPositionAnimation.autoreverses = true
        fromView.layer.add(fromOfPositionAnimation, forKey: "moves")

        let toOfPositionAnimation = CABasicAnimation(keyPath: "position.x")
        switch self.movementType {
        case .clockwise:
            toOfPositionAnimation.toValue = toView.frame.width
        case .counterclockwise:
            toOfPositionAnimation.toValue = 0
        }
        toOfPositionAnimation.autoreverses = true
        toView.layer.add(toOfPositionAnimation, forKey: "moves")

        CATransaction.commit()
    }

    // 旋轉與縮放
    func zoomAnimation(using transitionContext: UIViewControllerContextTransitioning, fromView: UIView, toView: UIView) {
        let duration = self.transitionDuration(using: transitionContext)

        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)

        var fromViewTransform = CATransform3DIdentity
        fromViewTransform = CATransform3DTranslate(fromViewTransform, 0, 0, -500)
        fromViewTransform.m34 = -1 / 450
        fromViewTransform = CATransform3DScale(fromViewTransform, 0.5, 0.5, 0.5)
        switch self.movementType {
        case .clockwise:
            fromViewTransform = CATransform3DRotate(fromViewTransform, degrees2Radians(45), 0, 1, 0)
        case .counterclockwise:
            fromViewTransform = CATransform3DRotate(fromViewTransform, degrees2Radians(-45), 0, 1, 0)
        }

        let fromOfTransformAnimation = CABasicAnimation(keyPath: "transform")
        fromOfTransformAnimation.toValue = fromViewTransform
        fromOfTransformAnimation.autoreverses = false
        fromOfTransformAnimation.isRemovedOnCompletion = false
        fromOfTransformAnimation.fillMode = kCAFillModeForwards
        fromView.layer.add(fromOfTransformAnimation, forKey: "zoomIn")


        var toViewTransform = CATransform3DIdentity
        toViewTransform = CATransform3DTranslate(toViewTransform, 0, 0, -500)
        toViewTransform.m34 = -1 / 450
        toViewTransform = CATransform3DScale(toViewTransform, 0.5, 0.5, 0.5)
        switch self.movementType {
        case .clockwise:
            toViewTransform = CATransform3DRotate(toViewTransform, degrees2Radians(-45), 0, 1, 0)
        case .counterclockwise:
            toViewTransform = CATransform3DRotate(toViewTransform, degrees2Radians(45), 0, 1, 0)
        }

        let toOfTransformAnimation = CABasicAnimation(keyPath: "transform")
        toOfTransformAnimation.fromValue = toViewTransform
        toOfTransformAnimation.toValue = CATransform3DIdentity
        toOfTransformAnimation.autoreverses = false
        toOfTransformAnimation.isRemovedOnCompletion = false
        toOfTransformAnimation.fillMode = kCAFillModeForwards
        toView.layer.add(toOfTransformAnimation, forKey: "zoomOut")

        CATransaction.commit()
    }
}
