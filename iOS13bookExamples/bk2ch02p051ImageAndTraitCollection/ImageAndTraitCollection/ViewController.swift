

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
        
        do {
            let tcdisp = UITraitCollection(displayScale: UIScreen.main.scale)
            let tcphone = UITraitCollection(userInterfaceIdiom: .phone)
            let tcreg = UITraitCollection(verticalSizeClass: .regular)
            let tc1 = UITraitCollection(traitsFrom: [tcdisp, tcphone, tcreg])
            let tccom = UITraitCollection(verticalSizeClass: .compact)
            let tc2 = UITraitCollection(traitsFrom: [tcdisp, tcphone, tccom])
            _ = (tc1,tc2)
        }
        
        // decided the preceding code was too artificial; this is more realistic
        
        
        let tcreg = UITraitCollection(verticalSizeClass: .regular)
        let tccom = UITraitCollection(verticalSizeClass: .compact)
        let moods = UIImageAsset()
        let frowney = UIImage(named:"frowney")!.withRenderingMode(.alwaysOriginal)
        let smiley = UIImage(named:"smiley")!.withRenderingMode(.alwaysOriginal)
        moods.register(frowney, with: tcreg)
        moods.register(smiley, with: tccom)
        
        let tc = self.traitCollection
        let im = moods.image(with: tc)
        self.iv2.image = im
        
        self.b.setImage(im, for: .normal)
        self.b.setImage(im, for: .highlighted)
        
        // actually any of these will do; that's the Really Amazing Part
        self.v.image = im
        self.v.image = frowney
        self.v.image = smiley

    }


}

