

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController {
    
    
}

class MySlider: UISlider {
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        
        let t = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(t)
        
        //    self.superview.tintColor = .red
        //    self.minimumTrackTintColor = .yellow
        //    self.maximumTrackTintColor = .green
        //    self.thumbTintColor = UIColor.orange()
        
        self.setThumbImage(UIImage(named:"moneybag1.png")!, for:.normal)
        
        
        
        let coinEnd = UIImage(named:"coin2.png")!.resizableImage(withCapInsets:
            UIEdgeInsets(top: 0,left: 7,bottom: 0,right: 7), resizingMode: .stretch)
        
        
        self.setMinimumTrackImage(coinEnd, for:.normal)
        self.setMaximumTrackImage(coinEnd, for:.normal)
        
        // self.bounds.size.height += 30
    }
    
    // supply sufficient height to make new thumb image touchable
    // we are using autolayout so this works
    // otherwise we'd use the bound, above
    override var intrinsicContentSize : CGSize {
        var sz = super.intrinsicContentSize
        sz.height += 30
        return sz
    }
    
    @objc func tapped(_ g:UIGestureRecognizer) {
        let s = g.view as! UISlider
        if s.isHighlighted {
            return // tap on thumb, let slider deal with it
        }
        let pt = g.location(in:s)
        let track = s.trackRect(forBounds: s.bounds)
        if !track.insetBy(dx: 0, dy: -10).contains(pt) {
            return // not on track, forget it
        }
        let percentage = pt.x / s.bounds.size.width
        let delta = Float(percentage) * (s.maximumValue - s.minimumValue)
        let value = s.minimumValue + delta
        delay(0.1) {
            UIView.animate(withDuration: 0.15) {
                s.setValue(value, animated:true) // NB behold the secret of getting animation
            }
        }
    }
    
    override func maximumValueImageRect(forBounds bounds: CGRect) -> CGRect {
        return super.maximumValueImageRect(forBounds:bounds).offsetBy(dx: 31, dy: 0)
    }
    
    override func minimumValueImageRect(forBounds bounds: CGRect) -> CGRect {
        return super.minimumValueImageRect(forBounds: bounds).offsetBy(dx: -31, dy: 0)
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.trackRect(forBounds: bounds)
        result.origin.x = 0
        result.size.width = bounds.size.width
        return result
    }

    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        return super.thumbRect(forBounds:
            bounds, trackRect: rect, value: value)
            .offsetBy(dx: 0, dy: -7)
    }
    

//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let tr = self.trackRect(forBounds: self.bounds)
//        if tr.contains(point) { return self }
//        let r = self.thumbRect(forBounds: self.bounds, trackRect: tr, value: self.value)
//        if r.contains(point) { return self }
//        return nil
//    }
    

}
