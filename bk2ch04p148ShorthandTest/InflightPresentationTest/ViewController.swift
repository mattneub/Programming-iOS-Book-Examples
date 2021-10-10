
import UIKit

extension Task where Success == Never, Failure == Never {
    static func sleep(_ seconds:Double) async {
        await self.sleep(UInt64(seconds * 1_000_000_000))
    }
    static func sleepThrowing(_ seconds:Double) async throws {
        try await self.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

// see https://stackoverflow.com/questions/61258341/core-animation-short-hand-causes-odd-behaviour

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            let someLayer = CALayer()
            someLayer.frame = .init(x: 50, y: 50, width: 100, height: 100)
            someLayer.backgroundColor = UIColor.red.cgColor
            self.view.layer.addSublayer(someLayer)

            await Task.sleep(2.0)

            // interesting that we can omit this...
            // perhaps because the explicit animation cancels the implicit animation
            // CATransaction.setDisableActions(true) // disable implicit animation
            let anim = CABasicAnimation(keyPath: "bounds.size.width")
            anim.duration = 2
            // if you comment out the next line, the animation still works...
            // but the presentation layer bounds value midflight is wrong
            anim.fromValue = someLayer.bounds.size.width
            // anim.toValue = 200 // ok to omit this
            someLayer.bounds.size.width = 200
            someLayer.add(anim, forKey: nil)

            await Task.sleep(1.0)

            print(someLayer.presentation()?.bounds as Any)
        }

    }


}

