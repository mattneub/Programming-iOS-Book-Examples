
//  Mandelbrot drawing code based on https://github.com/ddeville/Mandelbrot-set-on-iPhone

import UIKit

class MyMandelbrotView : UIView {

    var bitmapContext: CGContext!
    var odd = false
    
    let queue : NSOperationQueue = {
        let q = NSOperationQueue()
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    func drawThatPuppy () {
        let center = CGPointMake(self.bounds.midX, self.bounds.midY)
        let op = MyMandelbrotOperation(size: self.bounds.size, center: center, zoom: 1)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "operationFinished:", name: "MyMandelbrotOperationFinished", object: op)
        self.queue.addOperation(op)
    }
    
    // warning! called on background thread
    func operationFinished(n:NSNotification) {
        if let op = n.object as? MyMandelbrotOperation {
            dispatch_async(dispatch_get_main_queue()) {
                NSNotificationCenter.defaultCenter().removeObserver(self, name: "MyMandelbrotOperationFinished", object: op)
                self.bitmapContext = op.bitmapContext
                self.setNeedsDisplay()
            }
        }
    }
    
    // turn pixels of self.bitmapContext into CGImage, draw into ourselves
    override func drawRect(rect: CGRect) {
        if self.bitmapContext != nil {
            let context = UIGraphicsGetCurrentContext()
            let im = CGBitmapContextCreateImage(self.bitmapContext)
            CGContextDrawImage(context, self.bounds, im)
            self.odd = !self.odd
            self.backgroundColor = self.odd ? UIColor.greenColor() : UIColor.redColor()
        }
    }
    
    deinit {
        self.queue.cancelAllOperations()
    }

    
}
