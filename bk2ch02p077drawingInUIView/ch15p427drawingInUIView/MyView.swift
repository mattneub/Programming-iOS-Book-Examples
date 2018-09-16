
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


class MyView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.isOpaque = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let which = 6
    
    override func draw(_ rect: CGRect) {
        switch which {
        case 1:
            let con = UIGraphicsGetCurrentContext()!
            
            // draw a black (by default) vertical line, the shaft of the arrow
            con.move(to:CGPoint(100, 100))
            con.addLine(to:CGPoint(100, 19))
            con.setLineWidth(20)
            con.strokePath()
            
            // draw a red triangle, the point of the arrow
            con.setFillColor(UIColor.red.cgColor)
            con.move(to:CGPoint(80, 25))
            con.addLine(to:CGPoint(100, 0))
            con.addLine(to:CGPoint(120, 25))
            con.fillPath()
            
            // snip a triangle out of the shaft by drawing in Clear blend mode
            con.move(to:CGPoint(90, 101))
            con.addLine(to:CGPoint(100, 90))
            con.addLine(to:CGPoint(110, 101))
            con.setBlendMode(.clear)
            con.fillPath()
            
        case 2:
            let p = UIBezierPath()
            // shaft
            p.move(to:CGPoint(100,100))
            p.addLine(to:CGPoint(100, 19))
            p.lineWidth = 20
            p.stroke()
            // point
            UIColor.red.set()
            p.removeAllPoints()
            p.move(to:CGPoint(80,25))
            p.addLine(to:CGPoint(100, 0))
            p.addLine(to:CGPoint(120, 25))
            p.fill()
            // snip
            p.removeAllPoints()
            p.move(to:CGPoint(90,101))
            p.addLine(to:CGPoint(100, 90))
            p.addLine(to:CGPoint(110, 101))
            p.fill(with:.clear, alpha:1.0)
            
        case 3:
            
            // obtain the current graphics context
            let con = UIGraphicsGetCurrentContext()!
            
            // punch triangular hole in context clipping region
            con.move(to:CGPoint(90, 100))
            con.addLine(to:CGPoint(100, 90))
            con.addLine(to:CGPoint(110, 100))
            con.closePath()
            con.addRect(con.boundingBoxOfClipPath)
            con.clip(using:.evenOdd)
            
            // draw the vertical line
            con.move(to:CGPoint(100, 100))
            con.addLine(to:CGPoint(100, 19))
            con.setLineWidth(20)
            con.strokePath()
            
            // draw the red triangle, the point of the arrow
            con.setFillColor(UIColor.red.cgColor)
            con.move(to:CGPoint(80, 25))
            con.addLine(to:CGPoint(100, 0))
            con.addLine(to:CGPoint(120, 25))
            con.fillPath()
            
        case 4:
            // obtain the current graphics context
            let con = UIGraphicsGetCurrentContext()!
            //con.saveGState()
            
            // punch triangular hole in context clipping region
            con.move(to:CGPoint(90, 100))
            con.addLine(to:CGPoint(100, 90))
            con.addLine(to:CGPoint(110, 100))
            con.closePath()
            con.addRect(con.boundingBoxOfClipPath)
            con.clip(using:.evenOdd)
            
            // draw the vertical line, add its shape to the clipping region
            con.move(to:CGPoint(100, 100))
            con.addLine(to:CGPoint(100, 19))
            con.setLineWidth(20)
            con.replacePathWithStrokedPath()
            con.clip()
            
            // draw the gradient
            let locs : [CGFloat] = [ 0.0, 0.5, 1.0 ]
            let colors : [CGFloat] = [
                0.8, 0.4, // starting color, transparent light gray
                0.1, 0.5, // intermediate color, darker less transparent gray
                0.8, 0.4, // ending color, transparent light gray
            ]
            let sp = CGColorSpaceCreateDeviceGray()
            // print(CGColorSpaceGetNumberOfComponents(sp))
            let grad =
                CGGradient(colorSpace:sp, colorComponents: colors, locations: locs, count: 3)!
            con.drawLinearGradient(grad, start: CGPoint(89,0), end: CGPoint(111,0), options:[])
            
            //con.restoreGState() // done clipping
            con.resetClip() // new in iOS 11? but works in iOS 10 too so maybe always existed?
            
            // draw the red triangle, the point of the arrow
            con.setFillColor(UIColor.red.cgColor)
            con.move(to:CGPoint(80, 25))
            con.addLine(to:CGPoint(100, 0))
            con.addLine(to:CGPoint(120, 25))
            con.fillPath()
            
        case 5:
            // obtain the current graphics context
            let con = UIGraphicsGetCurrentContext()!
            con.saveGState()
            
            // punch triangular hole in context clipping region
            con.move(to:CGPoint(90, 100))
            con.addLine(to:CGPoint(100, 90))
            con.addLine(to:CGPoint(110, 100))
            con.closePath()
            con.addRect(con.boundingBoxOfClipPath)
            con.clip(using:.evenOdd)
            
            // draw the vertical line, add its shape to the clipping region
            con.move(to:CGPoint(100, 100))
            con.addLine(to:CGPoint(100, 19))
            con.setLineWidth(20)
            con.replacePathWithStrokedPath()
            con.clip()
            
            // draw the gradient
            let locs : [CGFloat] = [ 0.0, 0.5, 1.0 ]
            let colors : [CGFloat] = [
                0.8, 0.4, // starting color, transparent light gray
                0.1, 0.5, // intermediate color, darker less transparent gray
                0.8, 0.4, // ending color, transparent light gray
            ]
            let sp = CGColorSpaceCreateDeviceGray()
            let grad =
                CGGradient(colorSpace:sp, colorComponents: colors, locations: locs, count: 3)!
            con.drawLinearGradient(grad, start: CGPoint(89,0), end: CGPoint(111,0), options: [])
            
            con.restoreGState() // done clipping
            
            // draw the red triangle, the point of the arrow
            let r = UIGraphicsImageRenderer(size:CGSize(4,4))
            let stripes = r.image {
                ctx in
                let imcon = ctx.cgContext
                imcon.setFillColor(UIColor.red.cgColor)
                imcon.fill(CGRect(0,0,4,4))
                imcon.setFillColor(UIColor.blue.cgColor)
                imcon.fill(CGRect(0,0,4,2))
            }
            
//            UIGraphicsBeginImageContextWithOptions(CGSize(4,4), false, 0)
//            let imcon = UIGraphicsGetCurrentContext()!
//            imcon.setFillColor(UIColor.red().cgColor)
//            imcon.fill(CGRect(0,0,4,4))
//            imcon.setFillColor(UIColor.blue().cgColor)
//            imcon.fill(CGRect(0,0,4,2))
//            let stripes = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
            
            let stripesPattern = UIColor(patternImage:stripes)
            stripesPattern.setFill()
            let p = UIBezierPath()
            p.move(to:CGPoint(80,25))
            p.addLine(to:CGPoint(100,0))
            p.addLine(to:CGPoint(120,25))
            p.fill()
            
        case 6:
            
            // obtain the current graphics context
            let con = UIGraphicsGetCurrentContext()!
            con.saveGState()
            
            // punch triangular hole in context clipping region
            con.move(to:CGPoint(90, 100))
            con.addLine(to:CGPoint(100, 90))
            con.addLine(to:CGPoint(110, 100))
            con.closePath()
            con.addRect(con.boundingBoxOfClipPath)
            con.clip(using:.evenOdd)
            
            // draw the vertical line, add its shape to the clipping region
            con.move(to:CGPoint(100, 100))
            con.addLine(to:CGPoint(100, 19))
            con.setLineWidth(20)
            con.replacePathWithStrokedPath()
            con.clip()
            
            // draw the gradient
            let locs : [CGFloat] = [ 0.0, 0.5, 1.0 ]
            let colors : [CGFloat] = [
                0.8, 0.4, // starting color, transparent light gray
                0.1, 0.5, // intermediate color, darker less transparent gray
                0.8, 0.4, // ending color, transparent light gray
            ]
            let sp = CGColorSpaceCreateDeviceGray()
            let grad =
                CGGradient(colorSpace:sp, colorComponents: colors, locations: locs, count: 3)!
            con.drawLinearGradient (grad, start: CGPoint(89,0), end: CGPoint(111,0), options: [])
            
            con.restoreGState() // done clipping
            
            
            // draw the red triangle, the point of the arrow
            con.saveGState()
            // this bug still present in beta 6 and GM
            do { // work around iOS 12 bug: force context to have some color!
                con.setFillColor(UIColor.blue.cgColor)
                con.fill(CGRect(0,0,0,0))
            }
            let sp2 = CGColorSpace(patternBaseSpace:nil)!
            con.setFillColorSpace(sp2)
            // hooray for Swift 2.0!
            let drawStripes : CGPatternDrawPatternCallback = {
                _, con in
                con.setFillColor(UIColor.red.cgColor)
                con.fill(CGRect(0,0,4,4))
                con.setFillColor(UIColor.blue.cgColor)
                con.fill(CGRect(0,0,4,2))
            }
            var callbacks = CGPatternCallbacks(
                version: 0, drawPattern: drawStripes, releaseInfo: nil)
            let patt = CGPattern(info:nil, bounds: CGRect(0,0,4,4),
                                 matrix: .identity,
                                 xStep: 4, yStep: 4,
                                 tiling: .constantSpacingMinimalDistortion,
                                 isColored: true, callbacks: &callbacks)!
            var alph : CGFloat = 1.0
            con.setFillPattern(patt, colorComponents: &alph)
            

            con.move(to:CGPoint(80, 25))
            con.addLine(to:CGPoint(100, 0))
            con.addLine(to:CGPoint(120, 25))
            con.fillPath()
            con.restoreGState()
            
            
        default: break
        }
    }
    
}
