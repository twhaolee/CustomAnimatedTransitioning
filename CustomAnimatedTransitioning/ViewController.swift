//
//  ViewController.swift
//  CustomAnimatedTransitioning
//
//  Created by Hao Lee on 2017/12/30.
//  Copyright © 2017年 Hao Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum AnimateStyle {
        case none
        case swap
        case swipe
    }
    var animateStyle = AnimateStyle.none

    var downTransitionController = DraggingDownInteractiveTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func animateTransitionWithDefault(_ sender: UIButton) {
        self.animateStyle = .none

        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "SecondViewController")
        let navigationController = UINavigationController(rootViewController: viewController)

        self.present(navigationController, animated: true)
    }

    @IBAction func animateCustomTransitionWithGeneral(_ sender: UIButton) {
        self.animateStyle = .swap

        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "SecondViewController")
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.transitioningDelegate = self

        self.present(navigationController, animated: true)
    }

    @IBAction func animateCustomTransitionWithSwipe(_ sender: UIButton) {
        self.animateStyle = .swipe

        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "SecondViewController")
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.transitioningDelegate = self
        self.downTransitionController.wire(to: viewController, otherViews: [navigationController.view])

        self.present(navigationController, animated: true)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch self.animateStyle {
        case .none:
            return nil
        case .swap:
            let animation = SwapAnimation()
            animation.movementType = .clockwise
            return animation
        case .swipe:
            return nil
        }
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch self.animateStyle {
        case .none:
            return nil
        case .swap:
            let animation = SwapAnimation()
            animation.movementType = .counterclockwise
            return animation
        case .swipe:
            return SwipeDismissAnimation()
        }
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard self.animateStyle == .swipe else {
            return nil
        }

        return self.downTransitionController
    }
}
