
//  Mandelbrot drawing code based on https://github.com/ddeville/Mandelbrot-set-on-iPhone

import UIKit

class MyMandelbrotView : UIView {

    // best to run on device, because we want a slow processor in order to see the delay
    // you can increase the size of MANDELBROT_STEPS to make even more of a delay
    // but on my device, there's plenty of delay as is!
    
    // actually, in Swift, this is way slow in simulator, and WAY slow on device
    // good indication of Swift performance
    
    let MANDELBROT_STEPS = 200
    
    var bitmapContext: CGContext!
    var odd = false
    
    /*
    func drawThatPuppy () {
        self.makeBitmapContext(self.bounds.size)
        let center = CGPointMake(self.bounds.midX, self.bounds.midY)
        self.drawAtCenter(center, zoom:1)
        self.setNeedsDisplay()
    }
*/
    
    // you can see we're now threaded, because the button unhighlights immediately
    // but see warnings in book text as to why this whole architecture is no good!
    
    // ==== changes begin
    
    // jumping-off point: draw the Mandelbrot set
    func drawThatPuppy () {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        self.makeBitmapContext(self.bounds.size)
        let center = CGPointMake(self.bounds.midX, self.bounds.midY)
        let d = ["center":NSValue(CGPoint: center), "zoom":CGFloat(1)]
        self.performSelectorInBackground("reallyDraw:", withObject: d)
    }
    
    // trampoline, background thread entry point
    func reallyDraw(d:[NSObject:AnyObject]) {
        autoreleasepool {
            self.drawAtCenter((d["center"] as! NSValue).CGPointValue(), zoom: d["zoom"] as! CGFloat)
            self.performSelectorOnMainThread("allDone", withObject: nil, waitUntilDone: false)
        }
    }
    
    // called on main thread! background thread exit point
    func allDone() {
        self.setNeedsDisplay()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    // ==== changes end
    
    // ==== this material is now called on background thread
    
    // create bitmap context
    func makeBitmapContext(size:CGSize) {
        var bitmapBytesPerRow = Int(size.width * 4)
        bitmapBytesPerRow += (16 - (bitmapBytesPerRow % 16)) % 16
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let prem = CGImageAlphaInfo.PremultipliedLast.rawValue
        let context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), 8, bitmapBytesPerRow, colorSpace, prem)
        self.bitmapContext = context
    }
    
    // draw pixels of bitmap context
    func drawAtCenter(center:CGPoint, zoom:CGFloat) {
        func isInMandelbrotSet(re:Float, _ im:Float) -> Bool {
            var fl = true
            var (x, y, nx, ny) : (Float,Float,Float,Float) = (0,0,0,0)
            for _ in 0 ..< MANDELBROT_STEPS {
                nx = x*x - y*y + re
                ny = 2*x*y + im
                if nx*nx + ny*ny > 4 {
                    fl = false
                    break
                }
                x = nx
                y = ny
            }
            return fl
        }
        CGContextSetAllowsAntialiasing(self.bitmapContext, false)
        CGContextSetRGBFillColor(self.bitmapContext, 0, 0, 0, 1)
        var re : CGFloat
        var im : CGFloat
        let maxi = Int(self.bounds.size.width)
        let maxj = Int(self.bounds.size.height)
        for i in 0 ..< maxi {
            for j in 0 ..< maxj {
                re = (CGFloat(i) - 1.33 * center.x) / 160
                im = (CGFloat(j) - 1.0 * center.y) / 160
                re /= zoom
                im /= zoom
                if (isInMandelbrotSet(Float(re), Float(im))) {
                    CGContextFillRect (self.bitmapContext, CGRectMake(CGFloat(i), CGFloat(j), 1.0, 1.0))
                }
            }
        }
    }
    
    // ==== end of material called on background thread
    
    // turn pixels of bitmap context into CGImage, draw into ourselves
    override func drawRect(rect: CGRect) {
        if self.bitmapContext != nil {
            let context = UIGraphicsGetCurrentContext()!
            let im = CGBitmapContextCreateImage(self.bitmapContext)
            CGContextDrawImage(context, self.bounds, im)
            self.odd = !self.odd
            self.backgroundColor = self.odd ? UIColor.greenColor() : UIColor.redColor()
        }
    }

    
}
