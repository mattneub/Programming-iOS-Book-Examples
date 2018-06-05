import UIKit

class ViewController : UIViewController {
    @IBOutlet var b : UIButton!
    @IBOutlet var tbi : UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let window = UIApplication.shared.delegate!.window! {
            window.tintColor = UIColor.red
        }
        
        let im = UIImage(named:"Smiley")!.withRenderingMode(.alwaysTemplate)
        self.b.setBackgroundImage(im, for: .normal)
        
        let im2 = UIImage(named:"smiley2")!.withRenderingMode(.alwaysOriginal)
        self.tbi.image = im2
        
        // but with Xcode 6, this sort of thing is usually unnecessary!
        // look at the third button in the top row; it is template but with _no code_
        // that's because you can now set the rendering mode directly in the asset catalog
        
        // also demonstrated, another new Xcode 6 feature: vector art in the asset catalog! 
        // one size fits all, without rasterization
        // apparently only vector PDFs are acceptable
                
        
        let im3 = UIImage(named:"photo")!.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0))
        let iv = UIImageView(image:im3)
        self.view.addSubview(iv)
        iv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iv.leadingAnchor.constraint(equalTo:self.view.leadingAnchor),
            iv.bottomAnchor.constraint(equalTo:self.view.bottomAnchor)
            ])
        
        // the previous code aligns to bottom correctly
        // now, if alignment rectangle in asset catalog were working...
        // then I should be able to make the same setting in the asset catalog
        // and then I would just fetch the image directly
        // but it doesn't work, as I shall now show
        // OK, in Xcode 9 / iOS 11 this seems to be fixed!
        
        let im4 = UIImage(named:"photo")! // trying to use asset catalog alignment
        let iv2 = UIImageView(image:im4)
        self.view.addSubview(iv2)
        iv2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iv2.trailingAnchor.constraint(equalTo:self.view.trailingAnchor),
            iv2.bottomAnchor.constraint(equalTo:self.view.bottomAnchor)
            ])
        
        print(im4.alignmentRectInsets)
        print(iv2.alignmentRectInsets)
        
        // In the asset catalog, if I don't also set the Left, nothing happens at all;
        // a Left of 0 turns off the whole thing
        // I have a long-standing bug filed on this
        // (also the top and bottom used to be reversed)
        // OK, in Xcode 9 this seems to be fixed!

        let immm = UIImage(named:"photo2")!
        print(immm.alignmentRectInsets)
        
        /*
        let im5 = UIImage(named:"smiley2")!
        let b = UIButton(type: .System)
        b.setImage(im5.withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, 40, 0)), forState: .Normal)
        b.setTitle("Howdy", for:.normal)
        b.sizeToFit()
        self.view.addSubview(b)
*/

    }
}

