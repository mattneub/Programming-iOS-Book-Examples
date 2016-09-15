import UIKit

class ViewController : UIViewController {
    @IBOutlet var b : UIButton!
    @IBOutlet var tbi : UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let window = UIApplication.sharedApplication().delegate!.window! {
            window.tintColor = UIColor.redColor()
        }
        
        let im = UIImage(named:"Smiley")!.imageWithRenderingMode(.AlwaysTemplate)
        self.b.setBackgroundImage(im, forState: .Normal)
        
        let im2 = UIImage(named:"smiley2")!.imageWithRenderingMode(.AlwaysOriginal)
        self.tbi.image = im2
        
        // but with Xcode 6, this sort of thing is usually unnecessary!
        // look at the third button in the top row; it is template but with _no code_
        // that's because you can now set the rendering mode directly in the asset catalog
        
        // also demonstrated, another new Xcode 6 feature: vector art in the asset catalog! 
        // one size fits all, without rasterization
        // apparently only vector PDFs are acceptable
        
        // not demonstrated: setting alignment rectangle in asset catalog
        // (haven't figured this out yet)
        
        
        let im3 = UIImage(named:"photo")!.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, 24, 0))
        let iv = UIImageView(image:im3)
        self.view.addSubview(iv)
        iv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            iv.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor),
            iv.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor)
            ])
        
        // the previous code aligns to bottom correctly
        // now, if alignment rectangle in asset catalog were working...
        // then I should be able to make the same setting in the asset catalog
        // and then I would just fetch the image directly
        // but it doesn't work, as I shall now show
        
        let im4 = UIImage(named:"photo")! // trying to use asset catalog alignment
        let iv2 = UIImageView(image:im4)
        self.view.addSubview(iv2)
        iv2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            iv2.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor),
            iv2.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor)
            ])

        // In the asset catalog, it is the Top, not the Bottom, that I have set
        // Moreover, if I don't also set the Left, nothing happens at all; 
        // a Left of 0 turns off the whole thing
        
        print(im4.alignmentRectInsets) // C.UIEdgeInsets(top: 0.0, left: 0.5, bottom: 24.0, right: 0.0)
        // but what I set was the top!
        print(iv2.alignmentRectInsets())
        
        /*
        let im5 = UIImage(named:"smiley2")!
        let b = UIButton(type: .System)
        b.setImage(im5.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, 40, 0)), forState: .Normal)
        b.setTitle("Howdy", forState:.Normal)
        b.sizeToFit()
        self.view.addSubview(b)
*/

    }
}

