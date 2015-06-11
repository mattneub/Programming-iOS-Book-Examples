

import UIKit

class Dog {
    var whatADogSays = "woof"
    func bark() {
        println(self.whatADogSays)
    }
}
func doThis(f : Void -> Void) {
    f()
}

func imageOfSize(size:CGSize, whatToDraw:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    whatToDraw()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

func makeRoundedRectangle(sz:CGSize) -> UIImage {
    let image = imageOfSize(sz) {
        let p = UIBezierPath(
            roundedRect: CGRect(origin:CGPointZero, size:sz),
            cornerRadius: 8)
        p.stroke()
    }
    return image
}

func makeRoundedRectangleMaker(sz:CGSize) -> () -> UIImage {
    return {
        imageOfSize(sz) {
            let p = UIBezierPath(
                roundedRect: CGRect(origin:CGPointZero, size:sz),
                cornerRadius: 8)
            p.stroke()
        }
    }
}

// stop hard-coding the radius
func makeRoundedRectangleMaker2(sz:CGSize, rad:CGFloat) -> () -> UIImage {
    return {
        imageOfSize(sz) {
            let p = UIBezierPath(
                roundedRect: CGRect(origin:CGPointZero, size:sz),
                cornerRadius: rad)
            p.stroke()
        }
    }
}

// explicit curry
func makeRoundedRectangleMaker3(sz:CGSize) -> (CGFloat) -> UIImage {
    return {
        rad in
        imageOfSize(sz) {
            let p = UIBezierPath(
                roundedRect: CGRect(origin:CGPointZero, size:sz),
                cornerRadius: rad)
            p.stroke()
        }
    }
}

// implicit curry
func makeRoundedRectangleMaker4(sz:CGSize)(rad:CGFloat) -> UIImage {
    return imageOfSize(sz) {
        let p = UIBezierPath(
            roundedRect: CGRect(origin:CGPointZero, size:sz),
            cornerRadius: rad)
        p.stroke()
    }
}




class ViewController: UIViewController {
    
    @IBOutlet var myImageView : UIImageView!
    @IBOutlet weak var myImageView2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        let d = Dog()
        doThis(d.bark) // woof

        self.myImageView.image = makeRoundedRectangle(CGSizeMake(45,20))
        
        let maker = makeRoundedRectangleMaker(CGSizeMake(45,20))
        self.myImageView2.image = maker()
        
        let maker2 = makeRoundedRectangleMaker2(CGSizeMake(45,20), 8)
        let maker3 = makeRoundedRectangleMaker3(CGSizeMake(45,20))(8)
        let maker4 = makeRoundedRectangleMaker4(CGSizeMake(45,20))(rad:8)

    }


}

