

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var iv2: UIImageView!
    
    @IBOutlet weak var b: UIButton!
    @IBOutlet weak var v: MyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iv.image = UIImage(named:"Moods")
        
        // that was cool enough, but...
        // hold my beer and watch this!
        
        let tcdisp = UITraitCollection(displayScale: UIScreen.mainScreen().scale)
        let tcphone = UITraitCollection(userInterfaceIdiom: .Phone)
        let tcreg = UITraitCollection(verticalSizeClass: .Regular)
        let tc1 = UITraitCollection(traitsFromCollections: [tcdisp, tcphone, tcreg])
        let tccom = UITraitCollection(verticalSizeClass: .Compact)
        let tc2 = UITraitCollection(traitsFromCollections: [tcdisp, tcphone, tccom])
        let moods = UIImageAsset()
        let frowney = UIImage(named:"frowney")!.imageWithRenderingMode(.AlwaysOriginal)
        let smiley = UIImage(named:"smiley")!.imageWithRenderingMode(.AlwaysOriginal)
        moods.registerImage(frowney, withTraitCollection: tc1)
        moods.registerImage(smiley, withTraitCollection: tc2)
        
        let tc = self.traitCollection
        let im = moods.imageWithTraitCollection(tc)
        self.iv2.image = im
        
        self.b.setImage(im, forState: .Normal)
        self.b.setImage(im, forState: .Highlighted)
        
        self.v.image = im

    }


}

