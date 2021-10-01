
//  Mandelbrot drawing code based on https://github.com/ddeville/Mandelbrot-set-on-iPhone

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





class MyMandelbrotView : UIView {

    var bitmapContext: CGContext!
    var odd = false
    
    let queue : OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    func drawThatPuppy () {
        let center = self.bounds.center
        let op = MyMandelbrotOperation(center: center, bounds: self.bounds, zoom: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(operationFinished), name: MyMandelbrotOperation.mandelOpFinished, object: op)
        self.queue.addOperation(op)
    }
    
    // warning! called on background thread
    @objc func operationFinished(_ n:Notification) {
        if let op = n.object as? MyMandelbrotOperation {
            DispatchQueue.main.async {
                NotificationCenter.default.removeObserver(self, name: MyMandelbrotOperation.mandelOpFinished, object: op)
                self.bitmapContext = op.bitmapContext
                self.setNeedsDisplay()
            }
        }
    }
    
    // turn pixels of self.bitmapContext into CGImage, draw into ourselves
    override func draw(_ rect: CGRect) {
        if self.bitmapContext != nil {
            let context = UIGraphicsGetCurrentContext()!
            let im = self.bitmapContext.makeImage()
            context.draw(im!, in: self.bounds)
            self.odd = !self.odd
            self.backgroundColor = self.odd ? .green : .red
        }
    }
    
    deinit {
        self.queue.cancelAllOperations()
    }

    
}
