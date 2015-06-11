//
//  MyBoundedLabel.swift
//  bk1ch10p418subclassing
//
//  Created by Matt Neuburg on 5/9/15.
//  Copyright (c) 2015 Matt Neuburg. All rights reserved.
//

import UIKit

class MyBoundedLabel: UILabel {
    
    override func drawTextInRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextStrokeRect(context, CGRectInset(self.bounds, 1.0, 1.0))
        super.drawTextInRect(CGRectInset(rect, 5.0, 5.0))
    }

}
