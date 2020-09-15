

import UIKit

enum Archive : String {
    case color = "itsColor"
    case number = "itsNumber"
    case shape = "itsShape"
    case fill = "itsFill"
}


class MyView : UIView {
    override class var layerClass : AnyClass { CATiledLayer.self }
}

class NotMyView : UIView {
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        let s = coder.decodeObject(forKey:Archive.color.rawValue) as! String
        let ss = coder.decodeObject(forKey:Archive.color.rawValue) as? String
        if ss != nil {
            // ...
        }
        // for NSCoding types, better to talk like this
        let sss = coder.decodeObject(of: NSString.self, forKey: Archive.color.rawValue)
        // ...
        _ = s
        _ = sss
    }
}
