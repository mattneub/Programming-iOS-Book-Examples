

import UIKit

class MyMandelbrotOperation : Operation {
    private let center : CGPoint
    private let bounds : CGRect
    private let zoom : CGFloat
    private(set) var bitmapContext : CGContext! = nil
    
    static let mandelOpFinished = Notification.Name("mandelOpFinished")

    
    init(center c:CGPoint, bounds b:CGRect, zoom z:CGFloat) {
        self.center = c
        self.bounds = b
        self.zoom = z
        super.init()
    }
    
    let MANDELBROT_STEPS = 1000

    // create instance variable
    func makeBitmapContext(size:CGSize) {
        var bitmapBytesPerRow = Int(size.width * 4)
        bitmapBytesPerRow += (16 - (bitmapBytesPerRow % 16)) % 16
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let prem = CGImageAlphaInfo.premultipliedLast.rawValue
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: prem)
        self.bitmapContext = context
    }
    
    func draw(center:CGPoint, bounds:CGRect, zoom:CGFloat) {
        func isInMandelbrotSet(_ re:Float, _ im:Float) -> Bool {
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
        self.bitmapContext.setAllowsAntialiasing(false)
        self.bitmapContext.setFillColor(red: 0, green: 0, blue: 0, alpha: 1)
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
                    self.bitmapContext.fill (CGRect(CGFloat(i), CGFloat(j), 1.0, 1.0))
                }
            }
        }
    }
    
    override func main() {
        guard !self.isCancelled else {return}
        self.makeBitmapContext(size:self.bounds.size)
        self.draw(center: self.center, bounds: self.bounds, zoom: self.zoom)
        if !self.isCancelled {
            NotificationCenter.default.post(name: MyMandelbrotOperation.mandelOpFinished, object: self)
        }
    }

}
