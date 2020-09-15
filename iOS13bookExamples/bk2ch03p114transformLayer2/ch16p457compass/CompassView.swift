

import UIKit


func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


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

// view exists solely to host layer
class CompassView : UIView {
    override class var layerClass : AnyClass {
        return CompassLayer.self
    }
}

class CompassLayer : CALayer, CALayerDelegate {
    var arrow : CALayer?
    var rotationLayer : CALayer!
    var didSetup = false
    
    func doRotate () {
        print("rotate")

        self.rotationLayer.anchorPoint = CGPoint(1,0.5)
        self.rotationLayer.position = CGPoint(self.bounds.maxX, self.bounds.midY)
        self.rotationLayer.transform = CATransform3DMakeRotation(.pi/4.0, 0, 1, 0)

    
    }
    
    override func layoutSublayers() {
        print("CompassLayer layoutSublayers")
        if !self.didSetup {
            self.didSetup = true
            self.setup()
            delay(1) {self.doRotate()}
        }
    }
    
    func setup () {
        print("setup")
        
        CATransaction.setDisableActions(true)
        
        // we ourselves now have a sublayerTransform...
        
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/1000.0
        self.sublayerTransform = transform

        // ...and moreover our chief sublayer is now a CATransformLayer
        // to which the other layers are added

        // let master = CALayer()
        let master = CATransformLayer()
        master.frame = self.bounds
        self.addSublayer(master)
        self.rotationLayer = master

        
        // the gradient
        let g = CAGradientLayer()
        g.contentsScale = UIScreen.main.scale
        g.frame = self.bounds
        g.colors = [
           UIColor.black.cgColor,
           UIColor.red.cgColor
        ]
        g.locations = [0.0,1.0]
        master.addSublayer(g) //

        // the circle
        let circle = CAShapeLayer()
        circle.contentsScale = UIScreen.main.scale
        circle.lineWidth = 2.0
        circle.fillColor = UIColor(red:0.9, green:0.95, blue:0.93, alpha:0.9).cgColor
        circle.strokeColor = UIColor.gray.cgColor
        let p = CGMutablePath()
        p.addEllipse(in: self.bounds.insetBy(dx: 3, dy: 3))
        circle.path = p
        master.addSublayer(circle) //
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
        master.addSublayer(arrow) //
        arrow.setNeedsDisplay() // draw, please
        
        // add depth effects
        // circle.shadowOpacity = 0.4
        circle.zPosition = 10
        arrow.shadowOpacity = 1.0
        arrow.shadowRadius = 10
        arrow.zPosition = 20

        // "peg"
        let peg = CAShapeLayer()
        peg.contentsScale = UIScreen.main.scale // probably pointless
        peg.bounds = CGRect(0,0,3.5,50)
        let p2 = CGMutablePath()
        p2.addRect(peg.bounds)
        peg.path = p2
        peg.fillColor = UIColor(red:1.0, green:0.95, blue:1.0, alpha:0.95).cgColor
        peg.anchorPoint = CGPoint(0.5,0.5)
        peg.position = master.bounds.center
        master.addSublayer(peg)
        peg.setValue(Float.pi/2, forKeyPath:"transform.rotation.x") // can't use #keyPath here??
        peg.setValue(Float.pi/2, forKeyPath:"transform.rotation.z")
        peg.zPosition = 15
        


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

