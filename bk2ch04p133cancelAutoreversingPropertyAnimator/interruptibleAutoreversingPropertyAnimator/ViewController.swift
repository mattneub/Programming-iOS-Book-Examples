
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController {
    
    @IBOutlet var v: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delay(3) {
            self.count = 6
            self.test()
        }
    }
    
    var anim : UIViewPropertyAnimator!
    var count = 0
    func test() {
        var right = true
        func goOneWay() {
            self.anim = UIViewPropertyAnimator(duration: 1, curve: .easeInOut)
            self.anim.addAnimations {
                if right {
                    self.v.center.x += 100
                } else {
                    self.v.center.x -= 100
                }
            }
            self.anim.addCompletion { _ in
                self.count -= 1
                guard self.count > 0 else { return }
                right.toggle()
                goOneWay()
            }
            self.anim.startAnimation()
        }
        goOneWay()
    }

    @IBAction func doStop(_ sender: Any) {
        guard let anim = self.anim else {return}
        anim.pauseAnimation()
        anim.isReversed = self.count % 2 == 0
        self.count = 0
        anim.continueAnimation(
            withTimingParameters: nil, durationFactor: 0.1)
    }
    

}

