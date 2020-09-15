

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
extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}



class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v1 = UIView(frame:CGRect(113, 111, 132, 194))
        v1.backgroundColor = .systemRed
        let v2 = UIView(frame:CGRect(41, 56, 132, 194))
        v2.backgroundColor = .systemGreen
        let v3 = UIView(frame:CGRect(43, 197, 160, 230))
        v3.backgroundColor = .systemBlue
        self.view.addSubview(v1)
        v1.addSubview(v2)
        self.view.addSubview(v3)

        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurView)
        let vibEffect = UIVibrancyEffect(
            blurEffect: blurEffect, style: .label)
        let vibView = UIVisualEffectView(effect:vibEffect)
        let lab = UILabel()
        lab.text = "Hello, world!"
        lab.sizeToFit()
        vibView.bounds = lab.bounds
        vibView.center = self.view.bounds.center
        vibView.autoresizingMask =
            [.flexibleTopMargin, .flexibleBottomMargin,
            .flexibleLeftMargin, .flexibleRightMargin]
        blurView.contentView.addSubview(vibView)
        vibView.contentView.addSubview(lab)
        
        //vib.contentView.layer.borderWidth = 1
//        lab.center.x -= 20
//        vib.clipsToBounds = false
//        vib.contentView.clipsToBounds = false
    }



}

