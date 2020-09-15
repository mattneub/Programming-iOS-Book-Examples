
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


class MyView : UIView {
    
    override init (frame:CGRect) {
        super.init(frame:frame)
        self.backgroundColor = .red
        // clearRect will cause a black square
        self.backgroundColor = self.backgroundColor!.withAlphaComponent(1)
        // but uncomment the next line: clearRect will cause a clear square!
        // self.backgroundColor = self.backgroundColor!.withAlphaComponent(0.99)
        
        // also try uncommenting this next line with value true or false;
        // doing this after setting the background color gives you the last word
        // self.layer.isOpaque = false

        print("Layer opaque: \(self.layer.isOpaque)")
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func draw(_ rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()!
        con.setFillColor(UIColor.blue.cgColor)
        con.fill(rect)
        con.clear(CGRect(0,0,30,30))

    }
    
}
