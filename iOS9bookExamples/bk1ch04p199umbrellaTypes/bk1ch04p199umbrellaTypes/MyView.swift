

import UIKit

class MyView : UIView {
    override class func layerClass() -> AnyClass {
        return CATiledLayer.self
    }
}
