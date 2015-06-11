
import UIKit

func doThis(f:()->()) {
    f()
}

func imageOfSize(size:CGSize, whatToDraw:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    whatToDraw()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}




class ViewController: UIViewController {
    
    @IBOutlet weak var myButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        func whatToDo() {
            println("I did it")
        }
        doThis(whatToDo)
        
        
        
        func drawing() {
            let p = UIBezierPath(
                roundedRect: CGRectMake(0,0,45,20), cornerRadius: 8)
            p.stroke()
        }
        let image = imageOfSize(CGSizeMake(45,20), drawing)
        
        
        // here, I'll prove we really drew it :)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPointMake(100,100)
        self.view.addSubview(imageView)
        
    }
    
    @IBAction func moveMyButton (sender:AnyObject!) {
        
        
        func whatToAnimate() { // self.myButton is a button in the interface
            self.myButton.frame.origin.y += 20
        }
        func whatToDoLater(finished:Bool) {
            println("finished: \(finished)")
        }
        UIView.animateWithDuration(
            0.4, animations: whatToAnimate, completion: whatToDoLater)
        
        
    }

    


}

