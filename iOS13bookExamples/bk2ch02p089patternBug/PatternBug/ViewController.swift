//
//  ViewController.swift
//  PatternBug
//
//  Created by Matt Neuburg on 7/14/18.
//  Copyright © 2018 Matt Neuburg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let format = UIGraphicsImageRendererFormat.default()
        // uncomment next line if you want to see any color!
        // format.preferredRange = .standard
        // okay, looks like the bug is fixed in beta 5
        let rOuter = UIGraphicsImageRenderer(size: CGSize(width:100, height:100), format:format)
        let im = rOuter.image {
            ctx in
            // draw the red triangle, the point of the arrow
            let r = UIGraphicsImageRenderer(size:CGSize(width:4,height:4))
            let stripes = r.image {
                ctx in
                let imcon = ctx.cgContext
                imcon.setFillColor(UIColor.red.cgColor)
                imcon.fill(CGRect(x:0,y:0,width:4,height:4))
                imcon.setFillColor(UIColor.blue.cgColor)
                imcon.fill(CGRect(x:0,y:0,width:4,height:2))
            }
            let stripesPattern = UIColor(patternImage:stripes)
            stripesPattern.setFill()
            let imcon = ctx.cgContext
            imcon.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
        }
        let iv = UIImageView(image:im)
        iv.frame.origin = CGPoint(x: 100, y: 100)
        self.view.addSubview(iv)
    }


}

