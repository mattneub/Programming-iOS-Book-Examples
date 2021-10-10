

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController, CAAnimationDelegate {

    let leftfoot = CALayer()
    let rightfoot = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leftfoot.name = "left"
        self.leftfoot.contents = UIImage(named:"leftfoot")?.cgImage
        self.leftfoot.frame = CGRect(x: 100, y: 300, width: 50, height: 80)
        self.view.layer.addSublayer(self.leftfoot)

        self.rightfoot.name = "right"
        self.rightfoot.contents = UIImage(named:"rightfoot")?.cgImage
        self.rightfoot.frame = CGRect(x: 170, y: 300, width: 50, height: 80)
        self.view.layer.addSublayer(self.rightfoot)
        delay(2) {
            self.start()
        }
    }

    func start() {
        let firstLeftStep = CABasicAnimation(keyPath: "sublayers.left.position.y")
        firstLeftStep.byValue = -80
        firstLeftStep.duration = 1
        firstLeftStep.fillMode = .forwards
        func rightStepAfter(_ t: Double) -> CABasicAnimation {
            let rightStep = CABasicAnimation(keyPath: "sublayers.right.position.y")
            rightStep.byValue = -160
            rightStep.beginTime = t
            rightStep.duration = 2
            rightStep.fillMode = .forwards
            return rightStep
        }
        func leftStepAfter(_ t: Double) -> CABasicAnimation {
            let leftStep = CABasicAnimation(keyPath: "sublayers.left.position.y")
            leftStep.byValue = -160
            leftStep.beginTime = t
            leftStep.duration = 2
            leftStep.fillMode = .forwards
            return leftStep
        }
        let group = CAAnimationGroup()
        group.duration = 11
        group.animations = [firstLeftStep]
        for i in stride(from: 1, through: 9, by: 4) {
            group.animations?.append(rightStepAfter(Double(i)))
            group.animations?.append(leftStepAfter(Double(i+2)))
        }
        group.delegate = self
        self.view.layer.add(group, forKey: nil)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("done")
        self.rightfoot.removeFromSuperlayer()
        self.leftfoot.removeFromSuperlayer()
    }

}



