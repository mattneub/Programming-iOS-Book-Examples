

import UIKit

class Dog {
    var whatThisDogSays = "woof"
    func bark() {
        print(self.whatThisDogSays)
    }
}
struct Dog2 {
    var whatThisDogSays = "woof"
    func bark() {
        print(self.whatThisDogSays)
    }
}

func doThis(_ f : () -> ()) {
    f()
}

func imageOfSize(_ size:CGSize, _ whatToDraw: () -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    whatToDraw()
    let result = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return result
}

func makeRoundedRectangle(_ sz:CGSize) -> UIImage {
    let image = imageOfSize(sz) {
        let p = UIBezierPath(
            roundedRect: CGRect(origin:CGPoint.zero, size:sz),
            cornerRadius: 8)
        p.stroke()
    }
    return image
}

func makeRoundedRectangleMakerPrelim(_ sz:CGSize) -> () -> UIImage {
    func f () -> UIImage {
        let im = imageOfSize(sz) {
            let p = UIBezierPath(
                roundedRect: CGRect(origin:CGPoint.zero, size:sz),
                cornerRadius: 8)
            p.stroke()
        }
        return im
    }
    return f
}

func makeRoundedRectangleMakerPrelim2(_ sz:CGSize) -> () -> UIImage {
    func f () -> UIImage {
        return imageOfSize(sz) {
            let p = UIBezierPath(
                roundedRect: CGRect(origin:CGPoint.zero, size:sz),
                cornerRadius: 8)
            p.stroke()
        }
    }
    return f
}

func makeRoundedRectangleMakerPrelim3(_ sz:CGSize) -> () -> UIImage {
    return {
        return imageOfSize(sz) {
            let p = UIBezierPath(
                roundedRect: CGRect(origin:CGPoint.zero, size:sz),
                cornerRadius: 8)
            p.stroke()
        }
    }
}

func makeRoundedRectangleMaker(_ sz:CGSize) -> () -> UIImage {
    return {
        imageOfSize(sz) {
            let p = UIBezierPath(
                roundedRect: CGRect(origin:CGPoint.zero, size:sz),
                cornerRadius: 8)
            p.stroke()
        }
    }
}

// stop hard-coding the radius
func makeRoundedRectangleMaker2(_ sz:CGSize, _ r:CGFloat) -> () -> UIImage {
    return {
        imageOfSize(sz) {
            let p = UIBezierPath(
                roundedRect: CGRect(origin:CGPoint.zero, size:sz),
                cornerRadius: r)
            p.stroke()
        }
    }
}

// explicit curry
func makeRoundedRectangleMaker3(_ sz:CGSize) -> (CGFloat) -> UIImage {
    return {
        r in
        imageOfSize(sz) {
            let p = UIBezierPath(
                roundedRect: CGRect(origin:CGPoint.zero, size:sz),
                cornerRadius: r)
            p.stroke()
        }
    }
}


// implicit curry: deprecated in Swift 2.2, slated for removal in Swift 3

/*

func makeRoundedRectangleMaker4(sz:CGSize)(_ r:CGFloat) -> UIImage {
    return imageOfSize(sz) {
        let p = UIBezierPath(
            roundedRect: CGRect(origin:CGPointZero, size:sz),
            cornerRadius: r)
        p.stroke()
    }
}

 */



class ViewController: UIViewController {
    
    @IBOutlet var iv : UIImageView!
    @IBOutlet weak var iv2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // There is a difference in what "capture" means
        // depending on whether the surrounding is a value type or a reference type
        // I don't bring this out in the book, unfortunately
        // the tests below are much more extensive than anything I discuss in the book

        do {
        
            // Dog is a class instance
            
            let d = Dog()
            d.whatThisDogSays = "arf"
            let barkFunction = d.bark
            doThis(barkFunction) // arf
            doThis(d.bark) // arf

            d.whatThisDogSays = "ruff"
            doThis(barkFunction) // ruff
            doThis(d.bark) // ruff

            
        }
        
        do {
        
            // Dog2 is a struct instance
            
            var d = Dog2()
            d.whatThisDogSays = "arf"
            let barkFunction = d.bark
            doThis(barkFunction) // arf
            doThis(d.bark) // arf

            
            d.whatThisDogSays = "ruff" // makes a _different dog_
            doThis(barkFunction) // arf // the old dog is still captured in the closure
            doThis(d.bark) // ruff, because we are now fetching the new dog

            
        }
        
        do {
            func drawing() {
                let p = UIBezierPath(
                    roundedRect: CGRect(x:0,y:0,width:45,height:20), cornerRadius: 8)
                p.stroke()
            }
            let image = imageOfSize(CGSize(width:45,height:20), drawing)
            _ = image
        }
        
        do {
            let image = imageOfSize(CGSize(width:45,height:20)) {
                let p = UIBezierPath(
                    roundedRect: CGRect(x:0,y:0,width:45,height:20), cornerRadius: 8)
                p.stroke()
            }
            _ = image
        }

        do {
            let sz = CGSize(width:45,height:20)
            let image = imageOfSize(sz) {
                let p = UIBezierPath(
                    roundedRect: CGRect(origin:CGPoint.zero, size:sz), cornerRadius: 8)
                p.stroke()
            }
            _ = image
        }
        

        self.iv.image = makeRoundedRectangle(CGSize(width:45,height:20))
        
        do {
            let maker = makeRoundedRectangleMakerPrelim(CGSize(width:45,height:20))
            _ = maker
        }

        
        let maker = makeRoundedRectangleMaker(CGSize(width:45,height:20))
        self.iv2.image = maker()
        
        
        let maker2 = makeRoundedRectangleMaker2(CGSize(width:45,height:20), 8)
        _ = maker2
        
        let maker3 = makeRoundedRectangleMaker3(CGSize(width:45,height:20))
        self.iv.image = maker3(8)

        let image1 = makeRoundedRectangleMaker3(CGSize(width:45,height:20))(8)
        _ = image1
        
//        let maker4 = makeRoundedRectangleMaker4(CGSizeMake(45,20))
//        self.myImageView.image = maker4(8)
//
//        let image2 = makeRoundedRectangleMaker4(CGSizeMake(45,20))(8)
//        _ = image2


    }


}

