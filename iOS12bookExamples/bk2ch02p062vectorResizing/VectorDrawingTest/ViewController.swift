

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var iv2: UIImageView!
    
    // single Universal image
    // Preserve Vector Data must be on for this to work!
    override func viewDidLayoutSubviews() {
        // turn on Larger Text and also _use_ Larger Text, i.e. slide text size to the right
        // then long-press tab bar item; HUD appears...
        // but the image is not being enlarged!
        self.tabBarItem.largeContentSizeImage = UIImage(named: "rectangle")!
        // whoa, automatic resizing now works suddenly! beta 5
        return; // the following is no longer needed
        let im = UIImage(named:"rectangle")!
        let r = UIGraphicsImageRenderer(size:self.iv2.bounds.size, format:im.imageRendererFormat)
        let im2 = r.image {
            _ in
            im.draw(in: self.iv2.bounds)
        }
        self.iv2.image = im2
        self.iv2.contentMode = .center // prevent rasterization
    }
    
}

