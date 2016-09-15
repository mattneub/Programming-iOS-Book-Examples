

import UIKit
import MapKit


class MyOverlayRenderer : MKOverlayRenderer {
    var angle : CGFloat = 0
    
    init(overlay:MKOverlay, angle:CGFloat) {
        self.angle = angle
        super.init(overlay:overlay)
    }
    
    override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext) {
        // print isn't thread-safe
        // MKStringFromMapRect isn't available in Swift
        let s = "\(mapRect.origin.x) \(mapRect.origin.y) \(mapRect.size.width) \(mapRect.size.height)"
        NSLog("draw this: %@", s)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextSetFillColorWithColor(context,
        UIColor.redColor().colorWithAlphaComponent(0.2).CGColor)
        CGContextSetLineWidth(context, 1.2/zoomScale)
        
        let unit = CGFloat(MKMapRectGetWidth(self.overlay.boundingMapRect)/4.0)
        
        let p = CGPathCreateMutable()
        let start = CGPointMake(0, unit*1.5)
        let p1 = CGPointMake(start.x+2*unit, start.y)
        let p2 = CGPointMake(p1.x, p1.y-unit)
        let p3 = CGPointMake(p2.x+unit*2, p2.y+unit*1.5)
        let p4 = CGPointMake(p2.x, p2.y+unit*3)
        let p5 = CGPointMake(p4.x, p4.y-unit)
        let p6 = CGPointMake(p5.x-2*unit, p5.y)
        let points = [
            start, p1, p2, p3, p4, p5, p6
        ]
        // rotate the arrow around its center
        let t1 = CGAffineTransformMakeTranslation(unit*2, unit*2)
        let t2 = CGAffineTransformRotate(t1, self.angle)
        var t3 = CGAffineTransformTranslate(t2, -unit*2, -unit*2)
        // passing a Swift array of CGPoint where C expects a pointer to C array of CGPoint just works
        CGPathAddLines(p, &t3, points, 7)
        CGPathCloseSubpath(p)
        
        CGContextAddPath(context, p)
        CGContextDrawPath(context, .FillStroke)
    }
}



