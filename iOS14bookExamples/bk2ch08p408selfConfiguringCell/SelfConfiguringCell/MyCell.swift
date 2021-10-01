

import UIKit

class MyCell : UITableViewCell {
    @IBOutlet var theLabel : UILabel!
    @IBOutlet var theImageView : UIImageView!
    
    struct Configuration {
        let text: String
        let image: UIImage
    }
    func configure(_ configuration: Configuration) {
        let lab = self.theLabel!
        lab.text = configuration.text
        let iv = self.theImageView!
        let im = configuration.image
        let r = UIGraphicsImageRenderer(size:CGSize(36,36), format:im.imageRendererFormat)
        let im2 = r.image {
            _ in im.draw(in:CGRect(0,0,36,36))
        }
        iv.image = im2
        iv.contentMode = .center
    }
}

