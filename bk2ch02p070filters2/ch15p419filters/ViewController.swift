
import UIKit


class ViewController : UIViewController {
    @IBOutlet var iv : UIImageView!
    let context = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vig = MyVignetteFilter()
        let moici = CIImage(image: UIImage(named:"Moi")!)!
        vig.setValuesForKeysWithDictionary([
            "inputImage":moici,
            "inputPercentage":0.7
        ])
        let outim = vig.outputImage!

        let outimcg = self.context.createCGImage(outim, fromRect: outim.extent)
        self.iv.image = UIImage(CGImage: outimcg)
    }
    
}
