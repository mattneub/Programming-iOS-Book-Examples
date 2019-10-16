

import UIKit

enum Archive : String {
    case color = "itsColor"
    case number = "itsNumber"
    case shape = "itsShape"
    case fill = "itsFill"
}


class MyView : UIView {
    override class var layerClass : AnyClass {
        return CATiledLayer.self
    }
}

class NotMyView : UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        let s = aDecoder.decodeObject(forKey:Archive.color.rawValue) as! String
        let ss = aDecoder.decodeObject(forKey:Archive.color.rawValue) as? String
        if ss != nil {
            // ...
        }
        // for NSCoding types, better to talk like this
        let sss = aDecoder.decodeObject(of: NSString.self, forKey: Archive.color.rawValue)
        // ...
        _ = s
    }
}
