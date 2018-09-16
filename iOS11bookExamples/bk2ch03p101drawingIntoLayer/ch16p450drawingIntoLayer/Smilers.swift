

import UIKit

// Big change in iOS 10: CALayerDelegate is a real protocol!

class Smiler:NSObject, CALayerDelegate {
    func draw(_ layer: CALayer, in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        //[[UIImage imageNamed: @"smiley"] drawInRect:CGContextGetClipBoundingBox(ctx)];
        UIImage(named:"smiley")!.draw(at: .zero)
        UIGraphicsPopContext()
        print("\(#function)")
        print(layer.contentsGravity)
    }
}

class Smiler2:NSObject, CALayerDelegate {
    func display(_ layer: CALayer) {
        layer.contents = UIImage(named:"smiley")!.cgImage
        print("\(#function)")
        print(layer.contentsGravity)
    }
}

class SmilerLayer:CALayer {
    override func draw(in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        //[[UIImage imageNamed: @"smiley"] drawInRect:CGContextGetClipBoundingBox(ctx)];
        UIImage(named:"smiley")!.draw(at: .zero)
        UIGraphicsPopContext()
        print("\(#function)")
        print(self.contentsGravity)
    }
}

class SmilerLayer2:CALayer {
    override func display() {
        self.contents = UIImage(named:"smiley")!.cgImage
        print("\(#function)")
        print(self.contentsGravity)
    }
}
