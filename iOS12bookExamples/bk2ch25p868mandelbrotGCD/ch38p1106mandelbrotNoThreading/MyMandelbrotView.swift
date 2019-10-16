
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

class MyMandelbrotView : UIView {
    
    let MANDELBROT_STEPS = 1000
    
    var bitmapContext: CGContext!
    let draw_queue = DispatchQueue(label: "com.neuburg.mandeldraw")
    
    var odd = false
    
    // jumping-off point: draw the Mandelbrot set
    func drawThatPuppy () {
        // self.makeBitmapContext(CGSize.zero) // test "wrong thread" assertion
        // to test backgrounding, increase MANDELBROT_STEPS and suspend while calculating
        var bti : UIBackgroundTaskIdentifier = .invalid
        bti = UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(bti)
        }
        guard bti != .invalid else { return }
        let center = CGPoint(self.bounds.midX, self.bounds.midY)
        let bounds = self.bounds
        self.draw_queue.async {
            let bitmap = self.makeBitmapContext(size: bounds.size)
            self.draw(center: center, bounds: bounds, zoom: 1, context: bitmap)
            DispatchQueue.main.async {
                // testing crash
                // self.assertOnBackgroundThread() // crash! :)

                self.bitmapContext = bitmap
                self.setNeedsDisplay()
                UIApplication.shared.endBackgroundTask(bti)
            }
        }
    }
    
    // ==== this material is called on background thread
    
    func assertOnBackgroundThread() {
//        let s = DispatchQueue.getSpecific(key: qKey)
//        assert(s == qVal)
        
        // woohoo! much nicer way to do this, we can drop use of setSpecific and getSpecific
        
        dispatchPrecondition(condition: .onQueue(self.draw_queue))
    }

    
    // create and return context
    func makeBitmapContext(size:CGSize) -> CGContext { // *
        self.assertOnBackgroundThread()

        var bitmapBytesPerRow = Int(size.width * 4)
        bitmapBytesPerRow += (16 - (bitmapBytesPerRow % 16)) % 16
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let prem = CGImageAlphaInfo.premultipliedLast.rawValue
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: prem)
        return context!
    }
    
    // NB do NOT refer to self.bitmapContext here!
    func draw(center:CGPoint, bounds:CGRect, zoom:CGFloat, context:CGContext) {
        
        func isInMandelbrotSet(_ re:Float, _ im:Float) -> Bool {
            var fl = true
            var (x, y, nx, ny) : (Float, Float, Float, Float) = (0,0,0,0)
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

        
        self.assertOnBackgroundThread()

        context.setAllowsAntialiasing(false)
        context.setFillColor(red: 0, green: 0, blue: 0, alpha: 1)
        var re : CGFloat
        var im : CGFloat
        let maxi = Int(bounds.size.width)
        let maxj = Int(bounds.size.height)
        for i in 0 ..< maxi {
            for j in 0 ..< maxj {
                re = (CGFloat(i) - 1.33 * center.x) / 160
                im = (CGFloat(j) - 1.0 * center.y) / 160
                
                re /= zoom
                im /= zoom
                
                if (isInMandelbrotSet(Float(re), Float(im))) {
                    context.fill (CGRect(CGFloat(i), CGFloat(j), 1.0, 1.0))
                }
            }
        }
    }
    
    // ==== end of material called on background thread
    
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
    
}
