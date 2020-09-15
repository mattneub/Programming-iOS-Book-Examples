//
//  ViewController.swift
//  BigGreenBarInLandscapeOnIPad
//
//  Created by Matt Neuburg on 7/17/18.
//  Copyright © 2018 Matt Neuburg. All rights reserved.
//

import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class ViewController: UIViewController {

    var greenView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.greenView = UIView()
        self.greenView.backgroundColor = .green
        self.view.addSubview(self.greenView)
    }
    var changingSize = false
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("changing size")
        self.changingSize = true
    }
    override func viewWillLayoutSubviews() {
        print("layout")
        if self.changingSize || self.greenView.bounds == .zero {
            print("doing layout")
            self.changingSize = false
            func greenViewShouldAppear() -> Bool {
                let tc = self.traitCollection
                let sz = self.view.bounds.size
                if tc.horizontalSizeClass == .regular {
                    if sz.width > sz.height {
                        return true
                    }
                }
                return false
            }
            if greenViewShouldAppear() {
                self.greenView.frame = CGRect(
                    0, 0,
                    self.view.bounds.width/3.0, self.view.bounds.height
                )
            } else {
                self.greenView.frame = CGRect(
                    -self.view.bounds.width/3.0, 0,
                    self.view.bounds.width/3.0, self.view.bounds.height
                )
            }
        }
    }
    @IBAction func doButton(_ sender: Any) {
        self.view.setNeedsLayout()
    }
    
}

