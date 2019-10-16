//
//  ViewController.swift
//  LayoutDrivenTest
//
//  Created by Matt Neuburg on 7/16/18.
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

class Card : UIButton {
    static let tappedNotification = Notification.Name("tapped")
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    @objc func tapped(_ sender:UIGestureRecognizer) {
        NotificationCenter.default.post(
            name: Card.tappedNotification, object: self)
    }
}

class GameBoard : UIView {
    @IBOutlet weak var handView: UIView!
    var hand = [Card]() {
        didSet {
            self.setNeedsLayout()
        }
    }
    var cardOriginalPositions = [Card:CGPoint]()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tapped),
            name: Card.tappedNotification,
            object: nil)
        for v in self.subviews where v is Card {
            self.cardOriginalPositions[v as! Card] = v.center
        }
    }
    var animateTapResponse = true
    @objc func tapped(_ n:Notification) {
        guard let v = n.object as? Card else {return}
        if let ix = self.hand.firstIndex(of:v) {
            self.hand.remove(at:ix)
        } else {
            self.hand.append(v)
        }
        if self.animateTapResponse {
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        for (ix,v) in self.hand.enumerated() {
            let p = CGPoint(
                self.handView.frame.minX + 20 + v.bounds.width / 2.0 + (10 + v.bounds.width) * CGFloat(ix),
                self.handView.frame.minY + 10 + v.bounds.height / 2.0
            )
            v.center = p
        }
        for v in self.subviews where v is Card {
            if !self.hand.contains(v as! Card) {
                if let p = self.cardOriginalPositions[v as! Card] {
                    v.center = p
                }
            }
        }
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

