

import UIKit


class Smiler:NSObject {
    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        //[[UIImage imageNamed: @"smiley"] drawInRect:CGContextGetClipBoundingBox(ctx)];
        UIImage(named:"smiley")!.drawAtPoint(CGPoint())
        UIGraphicsPopContext()
        print("\(__FUNCTION__)")
        print(layer.contentsGravity)
    }
}

class Smiler2:NSObject {
    override func displayLayer(layer: CALayer) {
        layer.contents = UIImage(named:"smiley")!.CGImage
        print("\(__FUNCTION__)")
        print(layer.contentsGravity)
    }
}

class SmilerLayer:CALayer {
    override func drawInContext(ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        //[[UIImage imageNamed: @"smiley"] drawInRect:CGContextGetClipBoundingBox(ctx)];
        UIImage(named:"smiley")!.drawAtPoint(CGPoint())
        UIGraphicsPopContext()
        print("\(__FUNCTION__)")
        print(self.contentsGravity)
    }
}

class SmilerLayer2:CALayer {
    override func display() {
        self.contents = UIImage(named:"smiley")!.CGImage
        print("\(__FUNCTION__)")
        print(self.contentsGravity)
    }
}
