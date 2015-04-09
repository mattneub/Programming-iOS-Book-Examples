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
        
    }
}

