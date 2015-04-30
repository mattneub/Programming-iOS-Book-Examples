

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let greeting = "hello"
        let checkmark = "\u{21DA}"
        var n = 5
        let s = "You have \(n) widgets."

        let ud = NSUserDefaults.standardUserDefaults()
        // let s2 = "You have \(ud.integerForKey("widgets")) widgets." // compile error
        let n2 = ud.integerForKey("widgets")
        let s2 = "You have \(n2) widgets."

        let ss = "hello"
        let ss2 = " world"
        let greeting2 = ss + ss2
        
        var sss = "hello"
        let sss2 = " world"
        sss.extend(sss2) // or: sss += sss2

        let ssss = "hello"
        let ssss2 = "world"
        let space = " "
        let greeting3 = space.join([ssss,ssss2])

        let i = 7
        let sssss = String(i)
        let i2 = 31
        let sssss2 = String(i2, radix:16) // "1f"

        let ssssss = "31"
        let ii = ssssss.toInt() // Optional(31)

        let sssssss = "hello"
        let length = count(sssssss) // 5
        
        for c in sssssss {
            println(c) // print each Character on its own line
        }


    }


}

