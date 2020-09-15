//
//  ViewController.swift
//  NoStoryboardWindowScene
//
//  Created by Matt Neuburg on 6/30/19.
//  Copyright © 2019 Matt Neuburg. All rights reserved.
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
extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        let lab = UILabel()
        lab.text = "Hello world"
        lab.textColor = .white
        lab.sizeToFit()
        lab.center = self.view.bounds.center
        self.view.addSubview(lab)
    }


}

