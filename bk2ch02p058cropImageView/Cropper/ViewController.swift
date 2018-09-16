

import UIKit

/*
 Not in the book, but contains a number of techniques that perhaps should be:
 clamp, clamp rect, drag with limit,
 calculate portion of larger image displayed in aspect fill image view,
 crop image view's image based on rect imposed on image view
 */

func clamp<T:Comparable>(_ orig:T, _ lo:T, _ hi:T) -> T {
    return min(max(orig,lo),hi)
}

extension CGRect {
    mutating func rclamp(to r: CGRect) {
        self.origin.x =
            clamp(self.origin.x,
                  r.origin.x,
                  r.origin.x + r.size.width - self.size.width)
        self.origin.y =
            clamp(self.origin.y,
                  r.origin.y,
                  r.origin.y + r.size.height - self.size.height)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var iv : UIImageView!
    @IBOutlet var iv2 : UIImageView!
    
    @IBOutlet var draggableView : UIView! {
        didSet {
            draggableView.backgroundColor = .clear
            draggableView.layer.borderColor = UIColor.white.cgColor
            draggableView.layer.borderWidth = 4
            let p = UIPanGestureRecognizer(target: self, action: #selector(drag))
            draggableView.addGestureRecognizer(p)
            let t = UITapGestureRecognizer(target: self, action: #selector(crop))
            t.numberOfTapsRequired = 2
            draggableView.addGestureRecognizer(t)
        }
    }
    
    @objc func drag(_ p : UIPanGestureRecognizer) {
        let v = p.view!
        switch p.state {
        case .began, .changed:
            let delta = p.translation(in:v.superview)
            var c = v.center
            c.x += delta.x; c.y += delta.y
            v.center = c
            if !self.iv.frame.contains(v.frame) {
                // end gesture
                p.isEnabled = false
                p.isEnabled = true
                // clamp
                v.frame.rclamp(to:self.iv.frame)
                break; // unnecessary
            }
            p.setTranslation(.zero, in: v.superview)
        default: break
        }
    }

    @objc func crop(_ t : UITapGestureRecognizer) {
        let imsize = iv.image!.size
        let ivsize = iv.bounds.size
        
        var scale : CGFloat = ivsize.width / imsize.width
        if imsize.height * scale < ivsize.height {
            scale = ivsize.height / imsize.height
        }
        
        let dispSize = CGSize(width:ivsize.width/scale, height:ivsize.height/scale)
        let dispOrigin = CGPoint(x: (imsize.width-dispSize.width)/2.0,
                                 y: (imsize.height-dispSize.height)/2.0)
        
        let r = self.draggableView.convert(self.draggableView.bounds, to: self.iv)
        let cropRect =
            CGRect(x:r.origin.x/scale+dispOrigin.x,
                   y:r.origin.y/scale+dispOrigin.y,
                   width:r.width/scale,
                   height:r.height/scale)

        let rend = UIGraphicsImageRenderer(size:cropRect.size, format:self.iv.image!.imageRendererFormat)
        let croppedIm = rend.image { _ in
            self.iv.image!.draw(at: CGPoint(x:-cropRect.origin.x,
                                            y:-cropRect.origin.y))
        }
        
        self.iv2.image = croppedIm
    }
    


}

