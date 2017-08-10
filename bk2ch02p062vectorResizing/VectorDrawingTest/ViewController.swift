

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var iv2: UIImageView!
    
    // Preserve Vector Data must be on for this to work!
    override func viewDidLayoutSubviews() {
        let im = UIImage(named:"rectangle")!
        let r = UIGraphicsImageRenderer(size:self.iv2.bounds.size)
        let im2 = r.image {
            _ in
            im.draw(in: self.iv2.bounds)
        }
        self.iv2.image = im2
        self.iv2.contentMode = .center // prevent rasterization
    }
    
}

