
//  Mandelbrot drawing code based on https://github.com/ddeville/Mandelbrot-set-on-iPhone

import UIKit
import Combine

let backgroundTaskQueue : OperationQueue = {
    let q = OperationQueue()
    q.maxConcurrentOperationCount = 1
    return q
}()

func switchTo<Upstream:Publisher, S:Scheduler, T>(upstream:Upstream, on scheduler: S, andThen transform: @escaping (Upstream.Output) -> T) -> AnyPublisher<T, Upstream.Failure> {
    let p = Publishers.ReceiveOn(upstream: upstream, scheduler: scheduler, options: nil)
    let p2 = p.map(transform)
    return p2.eraseToAnyPublisher()
}

extension Publisher {
    func performOn<S:Scheduler, T>(_ scheduler: S, andThen transform: @escaping (Self.Output) -> T) -> AnyPublisher<T, Self.Failure> {
        let p = Publishers.ReceiveOn(upstream: self, scheduler: scheduler, options: nil)
        let p2 = p.map(transform)
        return p2.eraseToAnyPublisher()
    }
}

class MyMandelbrotView : UIView {
    
    let MANDELBROT_STEPS = 100
    
    var bitmapContext: CGContext!
    let draw_queue = DispatchQueue(label: "com.neuburg.mandeldraw")
    
    var odd = false
    
    // jumping-off point: draw the Mandelbrot set
        
    let trigger = PassthroughSubject<Void,Never>()
    lazy var pipeline : AnyCancellable = {
        self.configuredPipeline3()
    }()
    private func configuredPipeline() -> AnyCancellable {
        let pipeline = self.trigger
            .receive(on: DispatchQueue.main)
            .map { () -> (CGPoint, CGRect) in
                print("start on main")
                let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
                let bounds = self.bounds
                return (center:center, bounds:bounds)
            }
            .receive(on: draw_queue)
            .map { (center, bounds) -> CGContext in
                print("background start")
                let bitmap = self.makeBitmapContext(size: bounds.size)
                self.draw(center: center, bounds: bounds, zoom: 1, context: bitmap)
                print("background end")
                return bitmap
            }
            .receive(on: DispatchQueue.main)
            .map { (bitmap:CGContext) -> () in
                print("main again")
                self.bitmapContext = bitmap
                self.setNeedsDisplay()
            }
            .sink { _ in }
        return pipeline
    }
    
    private func configuredPipeline2() -> AnyCancellable {
        let p1 = switchTo(upstream: self.trigger, on: DispatchQueue.main) { () -> (CGPoint, CGRect) in
            print("start on main")
            let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            let bounds = self.bounds
            return (center:center, bounds:bounds)
        }
        let p2 = switchTo(upstream: p1, on: draw_queue) { (center, bounds) -> CGContext in
            print("background start")
            let bitmap = self.makeBitmapContext(size: bounds.size)
            self.draw(center: center, bounds: bounds, zoom: 1, context: bitmap)
            print("background end")
            return bitmap
        }
        let p3 = switchTo(upstream: p2, on: DispatchQueue.main) { (bitmap:CGContext) -> () in
            print("main again")
            self.bitmapContext = bitmap
            self.setNeedsDisplay()
        }
        return p3.sink { _ in }
    }
    
    private func configuredPipeline3() -> AnyCancellable {
        self.trigger
        .performOn(DispatchQueue.main) { () -> (CGPoint, CGRect) in
            print("start on main")
            let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            let bounds = self.bounds
            return (center:center, bounds:bounds)
        }
        .performOn(draw_queue) { (center, bounds) -> CGContext in
            print("background start")
            let bitmap = self.makeBitmapContext(size: bounds.size)
            self.draw(center: center, bounds: bounds, zoom: 1, context: bitmap)
            print("background end")
            return bitmap
        }
        .performOn(DispatchQueue.main) { (bitmap:CGContext) -> () in
            print("main again")
            self.bitmapContext = bitmap
            self.setNeedsDisplay()
        }
        .sink { _ in }
    }
    
    func drawThatPuppy () {
        _ = self.pipeline // tickle the lazy var
        self.trigger.send()
    }

    
    // create and return context
    func makeBitmapContext(size:CGSize) -> CGContext { // *
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
                    context.fill (CGRect(x: CGFloat(i), y: CGFloat(j), width: 1.0, height: 1.0))
                }
            }
        }
    }
    
    // ==== end of material called on background thread
    
    // turn pixels of self.bitmapContext into CGImage, draw into ourselves
    
    override func draw(_ rect: CGRect) {
        if self.bitmapContext != nil {
            let context = UIGraphicsGetCurrentContext()!
            context.setFillColor(self.odd ? UIColor.red.cgColor : UIColor.green.cgColor)
            self.odd.toggle()
            context.fill(self.bounds)
            
            if let im = self.bitmapContext.makeImage() {
                context.draw(im, in: self.bounds)
            }
        }
    }
    
}
