

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
extension CGRect {
    var center : CGPoint {
    return CGPoint(self.midX, self.midY)
    }
}

class CompassView : UIView {
    override class var layerClass : AnyClass {
        return CompassLayer.self
    }
    
    // view makes layer tappable
    @IBAction func tapped(_ t:UITapGestureRecognizer) {
        let p = t.location(ofTouch:0, in: self.superview)
        let hitLayer = self.layer.hitTest(p)
        if let arrow = (self.layer as? CompassLayer)?.arrow {
            if hitLayer == arrow { // respond to touch
                arrow.transform = CATransform3DRotate(
                    arrow.transform, .pi/4.0, 0, 0, 1)
            }
        }
    }
}

class CompassLayer : CALayer, CALayerDelegate {
    var arrow : CALayer!
    var rotationLayer : CALayer!
    var didSetup = false
    
    
    override func layoutSublayers() {
        if !self.didSetup {
            self.didSetup = true
            self.setup()
        }
    }
    
    // /*
    
    override func hitTest(_ p: CGPoint) -> CALayer? {
        var lay = super.hitTest(p)
        if lay == self.arrow {
            // artificially restrict touchability to roughly the shaft/point area
            let pt = self.arrow.convert(p, from:self.superlayer)
            let path = CGMutablePath()
            path.addRect(CGRect(10,20,20,80))
            path.move(to:CGPoint(0,25))
            path.addLine(to:CGPoint(20,0))
            path.addLine(to:CGPoint(40,25))
            path.closeSubpath()
            if !path.contains(pt, using: .winding) {
                lay = nil
            }
            let result = lay != nil ? "hit" : "missed"
            print("\(result) arrow at \(pt)")
        }
        return lay
    }

    // */
    
    func setup () {
        print("setup")
        
        // the gradient
        let g = CAGradientLayer()
        g.contentsScale = UIScreen.main.scale
        g.frame = self.bounds
        g.colors = [
                       UIColor.black.cgColor,
                       UIColor.red.cgColor
        ]
        g.locations = [0.0,1.0]
        self.addSublayer(g)
        
        // the circle
        let circle = CAShapeLayer()
        circle.contentsScale = UIScreen.main.scale
        circle.lineWidth = 2.0
        circle.fillColor = UIColor(red:0.9, green:0.95, blue:0.93, alpha:0.9).cgColor
        circle.strokeColor = UIColor.gray.cgColor
        let p = CGMutablePath()
        p.addEllipse(in: self.bounds.insetBy(dx: 3, dy: 3))
        circle.path = p
        self.addSublayer(circle)
        circle.bounds = self.bounds
        circle.position = self.bounds.center
        
        // the four cardinal points
        let pts = "NESW"
        for (ix,c) in pts.enumerated() {
            let t = CATextLayer()
            t.contentsScale = UIScreen.main.scale
            t.string = String(c)
            t.bounds = CGRect(0,0,40,40)
            t.position = circle.bounds.center
            let vert = circle.bounds.midY / t.bounds.height
            t.anchorPoint = CGPoint(0.5, vert)
            //print(t.anchorPoint)
            t.alignmentMode = .center
            t.foregroundColor = UIColor.black.cgColor
            t.setAffineTransform(CGAffineTransform(rotationAngle:CGFloat(ix) * .pi/2.0))
            circle.addSublayer(t)
        }
        
        
        // the arrow
        let arrow = CALayer()
        arrow.contentsScale = UIScreen.main.scale
        arrow.bounds = CGRect(0, 0, 40, 100)
        arrow.position = self.bounds.center
        arrow.anchorPoint = CGPoint(0.5, 0.8)
        arrow.delegate = self // we will draw the arrow in the delegate method
        // in Swift, not a property:
        arrow.setAffineTransform(CGAffineTransform(rotationAngle:.pi/5.0))
        self.addSublayer(arrow)
        arrow.setNeedsDisplay() // draw, please
        
        
        self.arrow = arrow

    }
    
    func draw(_ layer: CALayer, in con: CGContext) {
        print("drawLayer:inContext: for arrow")
        
        // Questa poi la conosco pur troppo!
        
        // punch triangular hole in context clipping region
        con.move(to: CGPoint(10,100))
        con.addLine(to: CGPoint(20,90))
        con.addLine(to: CGPoint(30,100))
        con.closePath()
        con.addRect(con.boundingBoxOfClipPath)
        con.clip(using: .evenOdd)
        
        // draw the vertical line, add its shape to the clipping region
        con.move(to: CGPoint(20,100))
        con.addLine(to: CGPoint(20,19))
        con.setLineWidth(20)
        con.strokePath()
        
        // draw the triangle, the point of the arrow
        let r = UIGraphicsImageRenderer(size:CGSize(4,4))
        let stripes = r.image {
            ctx in
            let imcon = ctx.cgContext
            imcon.setFillColor(UIColor.red.cgColor)
            imcon.fill(CGRect(0,0,4,4))
            imcon.setFillColor(UIColor.blue.cgColor)
            imcon.fill(CGRect(0,0,4,2))
        }

        
//        UIGraphicsBeginImageContextWithOptions(CGSize(4,4), false, 0)
//        let imcon = UIGraphicsGetCurrentContext()!
//        imcon.setFillColor(UIColor.red().cgColor)
//        imcon.fill(CGRect(0,0,4,4))
//        imcon.setFillColor(UIColor.blue().cgColor)
//        imcon.fill(CGRect(0,0,4,2))
//        let stripes = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
        let stripesPattern = UIColor(patternImage:stripes)
        
        UIGraphicsPushContext(con)
        stripesPattern.setFill()
        let p = UIBezierPath()
        p.move(to:CGPoint(0,25))
        p.addLine(to:CGPoint(20,0))
        p.addLine(to:CGPoint(40,25))
        p.fill()
        UIGraphicsPopContext()
        
    }
    
    
}
