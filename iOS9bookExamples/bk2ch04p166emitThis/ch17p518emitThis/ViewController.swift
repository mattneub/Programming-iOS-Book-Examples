

import UIKit


class ViewController : UIViewController {
    
    let which = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(10,10), false, 1)
        let con = UIGraphicsGetCurrentContext()!
        CGContextAddEllipseInRect(con, CGRectMake(0,0,10,10))
        CGContextSetFillColorWithColor(con, UIColor.grayColor().CGColor)
        CGContextFillPath(con)
        let im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let cell = CAEmitterCell()
        cell.birthRate = 5
        cell.lifetime = 1
        cell.velocity = 100
        cell.contents = im.CGImage
        
        let emit = CAEmitterLayer()
        emit.emitterPosition = CGPointMake(30,100)
        emit.emitterShape = kCAEmitterLayerPoint
        emit.emitterMode = kCAEmitterLayerPoints
        
        emit.emitterCells = [cell]
        self.view.layer.addSublayer(emit)
        
        switch which {
        case 0:
            break
        case 1...5:
            cell.birthRate = 100
            cell.lifetime = 1.5
            cell.velocity = 100
            cell.emissionRange = CGFloat(M_PI)/5.0
            
            cell.xAcceleration = -40
            cell.yAcceleration = 200
            
            cell.lifetimeRange = 0.4
            cell.velocityRange = 20
            cell.scaleRange = 0.2
            cell.scaleSpeed = 0.2
            
            cell.color = UIColor.blueColor().CGColor
            cell.greenRange = 0.5
            cell.greenSpeed = 0.75
            
            if which > 1 {fallthrough}
            
        case 2...5:
            cell.name = "circle"
            emit.setValue(3.0, forKeyPath:"emitterCells.circle.greenSpeed")

            if which > 2 {fallthrough}
            
        case 3...5:
            let key = "emitterCells.circle.greenSpeed"
            let ba = CABasicAnimation(keyPath:key)
            ba.fromValue = -1.0
            ba.toValue = 3.0
            ba.duration = 4
            ba.autoreverses = true
            ba.repeatCount = Float.infinity
            emit.addAnimation(ba, forKey:nil)

            if which > 3 {fallthrough}
            
        case 4...5:
            let cell2 = CAEmitterCell()
            cell.emitterCells = [cell2]
            cell2.contents = im.CGImage
            cell2.emissionRange = CGFloat(M_PI)
            cell2.birthRate = 200
            cell2.lifetime = 0.4
            cell2.velocity = 200
            cell2.scale = 0.2
            
            cell2.beginTime = 0.04
            cell2.duration = 0.2
            
            // return;
            
            // these next two lines are not causing the same result on iOS 7 as on iOS 6
            // I have filed a bug on this
            
            cell2.beginTime = 0.7
            cell2.duration = 0.8
            
            // interestingly, it looks about right on iOS 7...
            // ... if we double the beginTime and halve the duration
            
            cell2.beginTime = 1.4
            cell2.duration = 0.4
            
            if which > 4 {fallthrough}
            
        case 5:
            emit.emitterPosition = CGPointMake(100,25)
            emit.emitterSize = CGSizeMake(100,100)
            emit.emitterShape = kCAEmitterLayerLine
            emit.emitterMode = kCAEmitterLayerOutline
            cell.emissionLongitude = 3*CGFloat(M_PI)/4
            
            // might also be fun to animate position of source back and forth
            let ba2 = CABasicAnimation(keyPath:"emitterPosition")
            ba2.fromValue = NSValue(CGPoint:CGPointMake(30,100))
            ba2.toValue = NSValue(CGPoint:CGPointMake(200,100))
            ba2.duration = 6
            ba2.autoreverses = true
            ba2.repeatCount = Float.infinity
            emit.addAnimation(ba2, forKey:nil)
            

        default: break
        }
        

        


    }
    
}
