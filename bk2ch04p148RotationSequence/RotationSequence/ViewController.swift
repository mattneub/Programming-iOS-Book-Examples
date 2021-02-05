
import UIKit


class ViewController: UIViewController, CAAnimationDelegate {
    
    enum Direction {
        case counterClockwise
        case clockwise
        mutating func toggle() {
            self = (self == .clockwise) ? .counterClockwise : .clockwise
        }
    }

    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var combiLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    let lay = CAShapeLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goButton.isEnabled = true
        self.resetButton.isEnabled = false

        // create dial drawing, cute eh
        lay.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        let p = UIBezierPath.init(ovalIn: CGRect(x: 2, y: 2, width: 198, height: 198))
        lay.path = p.cgPath
        lay.lineWidth = 2
        lay.strokeColor = UIColor.black.cgColor
        lay.fillColor = UIColor.white.cgColor
        self.view.layer.addSublayer(lay)
        
        for i in 0...9 {
            let lay2 = CATextLayer()
            lay2.string = String(i)
            lay2.frame = CGRect(x: 80, y: 0, width: 40, height: 50)
            lay2.alignmentMode = .center
            lay2.foregroundColor = UIColor.red.cgColor
            lay.addSublayer(lay2)
            lay2.anchorPoint = CGPoint(x:0.5, y:2)
            lay2.position = CGPoint(x:100, y:100)
            lay2.setAffineTransform(CGAffineTransform(rotationAngle: .pi * 2 / 10 * CGFloat(i)))
        }
    }
    
    override func viewDidLayoutSubviews() {
        guard let sup = lay.superlayer else { return }
        let supBounds = sup.bounds
        lay.position = CGPoint(
            x:supBounds.midX,
            y:self.view.safeAreaInsets.top + 50 + lay.bounds.height/2)
    }
    
    func countSteps(from oldStop: Int, to newStop: Int, direction dir: Direction) -> Int {
        var diff = newStop - oldStop
        if newStop > oldStop {
            if dir == .clockwise {
                diff -= 10
            }
        } else {
            if dir == .counterClockwise {
                diff += 10
            }
        }
        return diff
    }
    @IBAction func doGo(_ sender: Any) {
        self.goButton.isEnabled = false
        
        // generate a combination at random
        // for simplicity I have eliminated 0 from the possible choices
        let stops = Array(sequence(first: 1) { $0 + 1 }.prefix(9)).shuffled().prefix(6)
        // let stops = "7—9—6—1—5—2".split(separator: "—").map {Int($0)!}
        
        // display the combination to the user
        self.combiLabel.text = stops.map(String.init).joined(separator: " — ")
        
        // transform the combination into numbers of steps starting at implicit zero
        var moves = [Int]()
        var prevStop = 0
        var dir = Direction.counterClockwise
        for stop in stops {
            moves.append(self.countSteps(from: prevStop, to: stop, direction: dir))
            prevStop = stop
            dir.toggle()
        }
        print(moves)
        
        // transform the numbers of steps into additive angles
        let angles : [CGFloat] = moves.map { -CGFloat.pi * 2 / 10 * CGFloat($0) }
        print(angles)
                
        // construct series of animations
        var animations = [CAAnimation]()
        var currentAngle = 0 as CGFloat
        var accumulatedTime = 0 as Double
        var first = true
        for additiveAngle in angles {
            let delay = first ? 0.0 : 0.2
            let absoluteAngle = currentAngle + additiveAngle
            let b = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
            b.valueFunction = CAValueFunction(name: .rotateZ)
            b.fromValue = currentAngle
            b.toValue = absoluteAngle
            b.beginTime = delay + accumulatedTime
            // all speeds should be the same
            // so duration needs to be proportional to additive angle
            let magicNumber = 0.7 // 0.7 is "magic number" (hey, Einstein did it)
            b.duration = abs(Double(additiveAngle)) * magicNumber
            b.fillMode = .forwards // otherwise we snap back to zero between numbers
            animations.append(b)

            currentAngle = absoluteAngle
            accumulatedTime += delay + b.duration
            first = false
        }
        
        let group = CAAnimationGroup()
        group.animations = animations
        group.duration = accumulatedTime
        group.delegate = self
        group.setValue("group", forKey: "name")
        self.lay.add(group, forKey:"group") // arbitrary, could be nil
        CATransaction.setDisableActions(true)
        self.lay.transform = CATransform3DMakeRotation(currentAngle, 0, 0, 1)
    }
    
    // animation delegate method
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.resetButton.isEnabled = true
    }
    
    @IBAction func doReset(_ sender: Any) {
        self.lay.transform = CATransform3DIdentity
        self.goButton.isEnabled = true
        self.resetButton.isEnabled = false
        self.combiLabel.text = ""
    }
    
}

