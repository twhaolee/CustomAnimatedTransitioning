//
//  SecondViewController.swift
//  CustomAnimatedTransitioning
//
//  Created by Hao Lee on 2018/1/23.
//  Copyright © 2018年 Hao Lee. All rights reserved.
//

import UIKit

extension UITableView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

protocol ScrollViewProtocol {
    var contentOffsetY: CGFloat { get }
}

class SecondViewController: UIViewController, ScrollViewProtocol {

    @IBOutlet var tableView: UITableView!

    var contentOffsetY: CGFloat {
        return self.tableView.contentOffset.y
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismissViewController(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}

extension SecondViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!

        cell.textLabel?.text = "Item: \(indexPath.row)"

        return cell
    }
}

extension SecondViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 && scrollView.isTracking {
            scrollView.bounces = false
            scrollView.contentOffset.y = 0
        } else {
            scrollView.bounces = true
        }
    }
}
