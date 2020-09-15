

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var iv2: UIImageView!
    
    // single Universal image
    // Preserve Vector Data must be on for this to work!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.largeContentSizeImage = UIImage(named: "rectangle")!
        var im = UIImage(named:"rectangle")!
        done: do {
            // comment out parts of this to play with it
            // let's play with new iOS 13 symbol images
            // im = UIImage(systemName: "rhombus")!
            // new in iOS 13, an image can have its own tint color
            // this is especially useful for vector images
            // play with combinations of im tint, iv tint, and rendering mode
            im = im.withTintColor(.green)
            self.iv2.tintColor = .yellow
            // im = im.withRenderingMode(.alwaysTemplate)
            im = im.withRenderingMode(.alwaysOriginal)
            // with rectangle, to get yellow must say alwaysTemplate
            // with rhombus, to get green must say alwaysOriginal
            // is that confusing or what????
        }
        self.iv2.image = im
        
        // let's prove that we can draw into an image context
        do {
            let iv = UIImageView()
            iv.translatesAutoresizingMaskIntoConstraints = false
            // let symbol = UIImage(systemName:"rhombus")!
            let symbol = UIImage.checkmark
            let sz = CGSize(100,100)
            let r = UIGraphicsImageRenderer(size:sz)
            let im = r.image {_ in
                symbol.withTintColor(.purple).draw(in:CGRect(origin:.zero, size:sz))
            }
            iv.image = im
            self.view.addSubview(iv)
            NSLayoutConstraint.activate([
                iv.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                iv.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//                iv.widthAnchor.constraint(equalToConstant: 100),
//                iv.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
    }
    
    // turn on Larger Text and also _use_ Larger Text, i.e. slide text size to the right
    // then long-press tab bar item; HUD appears...
    // but the image is not being enlarged!

}

