

import UIKit


class Smiler:NSObject {
    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        //[[UIImage imageNamed: @"smiley"] drawInRect:CGContextGetClipBoundingBox(ctx)];
        UIImage(named:"smiley")!.drawAtPoint(CGPoint())
        UIGraphicsPopContext()
        println("\(__FUNCTION__)")
        println(layer.contentsGravity)
    }
}

class Smiler2:NSObject {
    override func displayLayer(layer: CALayer) {
        layer.contents = UIImage(named:"smiley")!.CGImage
        println("\(__FUNCTION__)")
        println(layer.contentsGravity)
    }
}

class SmilerLayer:CALayer {
    override func drawInContext(ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        //[[UIImage imageNamed: @"smiley"] drawInRect:CGContextGetClipBoundingBox(ctx)];
        UIImage(named:"smiley")!.drawAtPoint(CGPoint())
        UIGraphicsPopContext()
        println("\(__FUNCTION__)")
        println(self.contentsGravity)
    }
}

class SmilerLayer2:CALayer {
    override func display() {
        self.contents = UIImage(named:"smiley")!.CGImage
        println("\(__FUNCTION__)")
        println(self.contentsGravity)
    }
}
