
import UIKit
import MapKit

class MyAnnotationView : MKAnnotationView {
    override init(annotation:MKAnnotation, reuseIdentifier:String) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let im = UIImage(named:"clipartdirtbike.gif")!
        self.frame = CGRectMake(0, 0, im.size.width / 3.0 + 5, im.size.height / 3.0 + 5)
        self.centerOffset = CGPointMake(0,-20)
        self.opaque = false
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func drawRect(rect: CGRect) {
        let im = UIImage(named:"clipartdirtbike.gif")!
        im.drawInRect(self.bounds.rectByInsetting(dx: 5, dy: 5))
    }
}
