
import UIKit

// world's simplest result builder

@resultBuilder enum SumBuilder {
    static func buildBlock(_ ints:Int...) -> Int {
        return ints.reduce(0,+)
    }
}

func add(@SumBuilder _ f: ()->Int) -> Int {
    return f()
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let sum = add {
            1
            2
            3
        }
        print(sum) // 6
    }


}

