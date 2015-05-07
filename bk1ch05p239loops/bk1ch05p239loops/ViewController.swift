

import UIKit

class ViewController: UIViewController {
    
    var movenda = [1,2,3]
    
    var boardView = UIView()
    
    var tiles : [UIView] = []
    var centers : [CGPoint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        while self.movenda.count > 0 {
            let p = self.movenda.removeLast()
            // ...
        }

        let tvc = UITableViewCell()
        let subview1 = UIView()
        let subview2 = UITextField()
        tvc.addSubview(subview1)
        subview1.addSubview(subview2)
        let textField = subview2
        var v : UIView = textField
        // v = tvc // try this to prove that we can cycle up to the top safely
        // do { v = v.superview! } while !(v is UITableViewCell)
        while let vv = v.superview where !(vv is UITableViewCell) {v = vv}
        if let tf = v.superview as? UITableViewCell {
            println("got it")
        } else {
            println("nope")
        }
        
        for var i = 1; i < 6; i++ {
            println(i)
        }
        for i in 1...5 {
            println(i)
        }
        var g = (1...5).generate()
        while let i = g.next() {
            println(i)
        }
        
        for v in self.boardView.subviews as! [UIView] {
            v.removeFromSuperview()
        }

        for (i,v) in enumerate(self.tiles) {
            v.center = self.centers[i]
        }
        
        for i in stride(from: 10, through: 0, by: -2) {
            println(i) // 10, 8, 6, 4, 2, 0
        }
        let range = lazy(0...10).reverse().filter{$0 % 2 == 0}
        for i in range {
            println(i) // 10, 8, 6, 4, 2, 0
        }

        let arr1 = ["CA", "MD", "NY", "AZ"]
        let arr2 = ["California", "Maryland", "New York"]
        var d = [String:String]()
        for (s1,s2) in zip(arr1,arr2) {
            d[s1] = s2
        } // now d is ["MD": "Maryland", "NY": "New York", "CA": "California"]

        var i : Int
        for i = 1; i < 6; i++ {
            println(i)
        }
        for var i = 1; i < 6; i++ {
            println(i)
        }
        
        if true {
            var v : UIView
            for v = textField; !(v is UITableViewCell); v = v.superview! {}
        }
        
        var values = [0.0]
        for (var i = 20, direction = 1.0; i < 60; i += 5, direction *= -1) {
            values.append( direction * M_PI / Double(i) )
        }

        for i in 1...5 {
            for j in 1...5 {
                println("\(i), \(j);")
                break
            }
        }

        outer: for i in 1...5 {
            for j in 1...5 {
                println("\(i), \(j);")
                break outer
            }
        }



    }



}

