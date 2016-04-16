

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
        
        let tcdisp = UITraitCollection(displayScale: UIScreen.main().scale)
        let tcphone = UITraitCollection(userInterfaceIdiom: .phone)
        let tcreg = UITraitCollection(verticalSizeClass: .regular)
        let tc1 = UITraitCollection(traitsFrom: [tcdisp, tcphone, tcreg])
        let tccom = UITraitCollection(verticalSizeClass: .compact)
        let tc2 = UITraitCollection(traitsFrom: [tcdisp, tcphone, tccom])
        let moods = UIImageAsset()
        let frowney = UIImage(named:"frowney")!.withRenderingMode(.alwaysOriginal)
        let smiley = UIImage(named:"smiley")!.withRenderingMode(.alwaysOriginal)
        moods.register(frowney, with: tc1)
        moods.register(smiley, with: tc2)
        
        let tc = self.traitCollection
        let im = moods.image(with: tc)
        self.iv2.image = im
        
        self.b.setImage(im, for: [])
        self.b.setImage(im, for: .highlighted)
        
        self.v.image = im

    }


}

