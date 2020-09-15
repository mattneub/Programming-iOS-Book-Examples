
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



let backgroundTaskQueue : OperationQueue = {
    let q = OperationQueue()
    q.maxConcurrentOperationCount = 1
    return q
}()

class MyMandelbrotView : UIView {
    
    let MANDELBROT_STEPS = 1000
    
    var bitmapContext: CGContext!
    let draw_queue = DispatchQueue(label: "com.neuburg.mandeldraw")
    
    var odd = false
    
    // jumping-off point: draw the Mandelbrot set
    
    var which : Int { return 2 } // 1 or 2
    
    func drawThatPuppy () {
        // self.makeBitmapContext(CGSize.zero) // test "wrong thread" assertion
        // to test backgrounding, increase MANDELBROT_STEPS and suspend while calculating
        switch which {
        case 1:
            var bti : UIBackgroundTaskIdentifier = .invalid
            bti = UIApplication.shared.beginBackgroundTask {
                UIApplication.shared.endBackgroundTask(bti)
            }
            guard bti != .invalid else { return }
            let center = self.bounds.center
            let bounds = self.bounds
            self.draw_queue.async {
                let bitmap = self.makeBitmapContext(size: bounds.size)
                self.draw(center: center, bounds: bounds, zoom: 1, context: bitmap)
                print("drew")
                DispatchQueue.main.async {
                    // testing crash
                    // self.assertOnBackgroundThread() // crash! :)

                    self.bitmapContext = bitmap
                    self.setNeedsDisplay()
                    print("finished")
                    UIApplication.shared.endBackgroundTask(bti)
                }
            }
        case 2:
            let center = self.bounds.center
            let bounds = self.bounds
            let bitmap = self.makeBitmapContext(size: bounds.size)
            let task = BackgroundTaskOperation()
            task.whatToDo = {
                print("starting to draw")
                self.draw(center: center, bounds: bounds, zoom: 1, context: bitmap)
                print("finished draw")
                DispatchQueue.main.async {
                    print(UIApplication.shared.backgroundTimeRemaining, "remaining")
                    print("main thread stuff")
                    self.bitmapContext = bitmap
                    self.setNeedsDisplay()
                }
            }
            task.cleanup = { print("let's pretend we have cleanup to do here") }
            backgroundTaskQueue.addOperation(task)
        default: break
        }
    }
    
    // ==== this material is called on background thread
    
    func assertOnBackgroundThread() {
//        let s = DispatchQueue.getSpecific(key: qKey)
//        assert(s == qVal)
        
        // woohoo! much nicer way to do this, we can drop use of setSpecific and getSpecific
        
        if which == 1 {
            dispatchPrecondition(condition: .onQueue(self.draw_queue))
        }
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
            print("I got a bitmap context")
            print(UIApplication.shared.applicationState.rawValue)
            // yeah, my little toggle trick doesn't work when we background...
            // because we get extra draw calls then
            // so to find out if we drew, just look at "I got a bitmap context"
            let context = UIGraphicsGetCurrentContext()!
            context.setFillColor(self.odd ? UIColor.red.cgColor : UIColor.green.cgColor)
            self.odd.toggle()
            context.fill(self.bounds)
            
            let im = self.bitmapContext.makeImage()
            context.draw(im!, in: self.bounds)
        }
    }
    
}
