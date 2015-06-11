

import UIKit

class MyMandelbrotOperation : NSOperation {
    private let size : CGSize
    private let center : CGPoint
    private let zoom : CGFloat
    private(set) var bitmapContext : CGContext! = nil
    
    init(size sz:CGSize, center c:CGPoint, zoom z:CGFloat) {
        self.size = sz
        self.center = c
        self.zoom = z
        super.init()
    }
    
    let MANDELBROT_STEPS = 200

    // create instance variable
    func makeBitmapContext(size:CGSize) {
        var bitmapBytesPerRow = Int(size.width * 4)
        bitmapBytesPerRow += (16 - (bitmapBytesPerRow % 16)) % 16
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let prem : CGBitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        let context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), 8, bitmapBytesPerRow, colorSpace, prem)
        self.bitmapContext = context
    }
    
    func drawAtCenter(center:CGPoint, zoom:CGFloat) {
        func isInMandelbrotSet(re:Float, im:Float) -> Bool {
            var fl = true
            var (x:Float, y:Float, nx:Float, ny:Float) = (0,0,0,0)
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
        let maxi = Int(self.size.width) // *
        let maxj = Int(self.size.height) // *
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
    
    override func main() {
        if self.cancelled {
            return
        }
        self.makeBitmapContext(self.size)
        self.drawAtCenter(self.center, zoom: self.zoom)
        if !self.cancelled {
            NSNotificationCenter.defaultCenter().postNotificationName("MyMandelbrotOperationFinished", object: self)
        }
    }

}
