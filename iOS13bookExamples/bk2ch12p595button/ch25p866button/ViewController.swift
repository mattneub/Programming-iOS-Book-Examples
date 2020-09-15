
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button : UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let im = UIImage(named:"coin")!
        let sz = im.size
        let im2 = im.resizableImage(withCapInsets:UIEdgeInsets(
            top: sz.height/2, left: sz.width/2, bottom: sz.height/2, right: sz.width/2),
            resizingMode: .stretch)
        self.button.setBackgroundImage(im2, for:.normal)
        self.button.backgroundColor = .clear
        self.button.setImage(im2, for:.normal)
        
        let mas = NSMutableAttributedString(string: "Pay Tribute", attributes: [
            .font: UIFont(name:"GillSans-Bold", size:16)!,
            .foregroundColor: UIColor.purple,
        ])
        mas.addAttributes([
            .strokeColor: UIColor.red,
            .strokeWidth: -2,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ], range: NSMakeRange(4, mas.length-4))
        self.button.setAttributedTitle(mas, for:.normal)
        
        let mas2 = mas.mutableCopy() as! NSMutableAttributedString
        mas2.addAttributes([
            .foregroundColor: UIColor.white
            ], range: NSMakeRange(0, mas2.length))
        self.button.setAttributedTitle(mas2, for: .highlighted)
        
        self.button.adjustsImageWhenHighlighted = true
        
        self.button2.titleLabel!.numberOfLines = 2
        self.button2.titleLabel!.textAlignment = .center
        self.button2.setTitle("Button with a title that wraps", for:.normal)
        
        do {
            let font = UIFont.systemFont(ofSize: 40)
            let config = UIImage.SymbolConfiguration(font: font)
            // legal, oddly
            self.button2.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        }
        
        // showing how the image drives out the title if it's too large
        do {
            var shrinkImage : Bool { return false } // change to true to shrink the image and show the title
            if shrinkImage {
                var im = self.button3.image(for: .normal)!
                im = UIGraphicsImageRenderer(size:CGSize(20,20)).image { _ in
                    im.draw(in:CGRect(0,0,20,20))
                }.withRenderingMode(.alwaysOriginal)
                self.button3.setImage(im, for:.normal)
            }
        }
        
        // new in iOS 13
        // you _can_ use a non symbol image, but don't
        let sys = UIButton.systemButton(with: UIImage(systemName: "smiley")!, target: nil, action: nil)
        sys.tintColor = .red
        let font = UIFont.systemFont(ofSize: 40)
        let config = UIImage.SymbolConfiguration(font: font)
        sys.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        // so you _can_ add text...
        // but it doesn't magically conform to the _symbol_ configuration
        sys.setTitle("Test", for: .normal)
        // so let's make them conform to one another
        sys.titleLabel?.font = font
        sys.sizeToFit() // crucial, or use autolayout
        sys.frame.origin = CGPoint(50, 350)
        sys.backgroundColor = .white
        self.view.addSubview(sys)
        
        // so what happens if you do that the old way?
        // it's exactly the same
        do {
            let sys = UIButton(type: .system)
            sys.setImage(UIImage(systemName: "smiley")!, for:.normal)
            sys.tintColor = .red
            let font = UIFont.systemFont(ofSize: 40)
            let config = UIImage.SymbolConfiguration(font: font)
            sys.setPreferredSymbolConfiguration(config, forImageIn: .normal)
            // so you _can_ add text...
            // but it doesn't magically conform to the _symbol_ configuration
            sys.setTitle("Test", for: .normal)
            // so let's make them conform to one another
            sys.titleLabel?.font = font
            sys.sizeToFit() // crucial, or use autolayout
            sys.frame.origin = CGPoint(250, 350)
            sys.backgroundColor = .white
            self.view.addSubview(sys)

        }
        
        let rr = UIButton(type: .close) // new type
        rr.setTitle("Test", for: .normal)
        rr.frame.origin = CGPoint(50,400)
        rr.sizeToFit()
        rr.tintColor = .red // no effect
        print(rr.currentBackgroundImage as Any) // circle
        print(rr.currentImage as Any) // xmark symbol image
        //rr.backgroundColor = .white
        rr.imageView?.tintColor = .green // nope
        self.view.addSubview(rr)
        
        // self.view.backgroundColor = .white
    }


}
