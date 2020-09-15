

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



class ViewController : UIViewController {
    
    let which = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // no longer needed; we now have a contentsScale! (starting in iOS 9)
//        let f = UIGraphicsImageRendererFormat.default()
//        f.scale = 1
        let r = UIGraphicsImageRenderer(size:CGSize(10,10))
        let im = r.image {
            ctx in let con = ctx.cgContext
            con.addEllipse(in:CGRect(0,0,10,10))
            con.setFillColor(UIColor.gray.cgColor)
            con.fillPath()
        }

//        UIGraphicsBeginImageContextWithOptions(CGSize(10,10), false, 1)
//        let con = UIGraphicsGetCurrentContext()!
//        con.addEllipse(inRect:CGRect(0,0,10,10))
//        con.setFillColor(UIColor.gray().cgColor)
//        con.fillPath()
//        let im = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
        let cell = CAEmitterCell()
        cell.contentsScale = UIScreen.main.scale // new in iOS 9
        cell.birthRate = 5
        cell.lifetime = 1
        cell.velocity = 100
        cell.contents = im.cgImage
        
        let emit = CAEmitterLayer()
        emit.emitterPosition = CGPoint(30,100)
        emit.emitterShape = .point
        emit.emitterMode = .points
        
        emit.emitterCells = [cell]
        self.view.layer.addSublayer(emit)
        
        switch which {
        case 0:
            break
        case 1...5:
            cell.birthRate = 100
            cell.lifetime = 1.5
            cell.velocity = 100
            cell.emissionRange = .pi/5.0
            
            cell.xAcceleration = -40
            cell.yAcceleration = 200
            
            cell.lifetimeRange = 0.4
            cell.velocityRange = 20
            cell.scaleRange = 0.2
            cell.scaleSpeed = 0.2
            
            cell.color = UIColor.blue.cgColor
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
            ba.repeatCount = .greatestFiniteMagnitude
            emit.add(ba, forKey:nil)

            if which > 3 {fallthrough}
            
        case 4...5:
            let cell2 = CAEmitterCell()
            cell.emitterCells = [cell2]
            cell2.contents = im.cgImage
            cell2.emissionRange = .pi
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
            emit.emitterPosition = CGPoint(100,25)
            emit.emitterSize = CGSize(100,100)
            emit.emitterShape = .line
            emit.emitterMode = .outline
            cell.emissionLongitude = 3 * .pi/4
            
            // might also be fun to animate position of source back and forth
            let ba2 = CABasicAnimation(keyPath:#keyPath(CAEmitterLayer.emitterPosition))
            ba2.fromValue = CGPoint(30,100)
            ba2.toValue = CGPoint(200,100)
            ba2.duration = 6
            ba2.autoreverses = true
            ba2.repeatCount = .greatestFiniteMagnitude
            emit.add(ba2, forKey:nil)
            

        default: break
        }
        

        


    }
    
}
