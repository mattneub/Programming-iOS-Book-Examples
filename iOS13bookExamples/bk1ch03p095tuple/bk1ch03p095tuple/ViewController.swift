

import UIKit
import Swift

func f (_ i1:Int, _ i2:Int) -> () {}
func f2 (i1:Int, i2:Int) -> () {}


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let pair : (Int, String) = (1, "Two")
            _ = pair
        }
        
        do {
            let pair = (1, "Two")
            _ = pair
        }
        
        do {
            let ix: Int
            let s: String
            (ix, s) = (1, "Two")
            _ = ix; _ = s
        }
        
        do {
            let (ix, s) = (1, "Two")
            _ = ix; _ = s
        }
        
        do {
            var s1 = "Hello"
            var s2 = "world"
            (s1, s2) = (s2, s1) // now s1 is "world" and s2 is "Hello"
        }
        
        do {
            let pair = (1, "Two")
            let (_, s) = pair // now s is "Two"
            _ = s
        }
        
        do {
            let s = "hello"
            for (ix,c) in s.enumerated() {
                print("character \(ix) is \(c)")
            }
        }
        
        // hey, it turns out these have names
        do {
            let s = "hello"
            for t in s.enumerated() {
                print("character \(t.offset) is \(t.element)")
            }
        }
        
        
        do {
            var pair = (1, "Two")
            let ix = pair.0 // now ix is 1
            pair.0 = 2 // now pair is (2, "Two")
            print(pair)
            _ = ix
        }
        
        do {
            let pair : (first:Int, second:String) = (1, "Two")
            _ = pair
        }
        
        do {
            let pair = (first:1, second:"Two")
            _ = pair
        }
        
        do {
            var pair = (first:1, second:"Two")
            let x = pair.first // 1
            pair.first = 2
            let y = pair.0 // 2
            _ = x; _ = y
        }
        
        do {
            let pair = (1, "Two")
            let pairWithNames : (first:Int, second:String) = pair
            let ix = pairWithNames.first // 1
            _ = pair
            _ = pairWithNames
            _ = ix
        }
        
        do {
            var pairWithoutNames = (1, "Two")
            pairWithoutNames = (first:2, second:"Two")
            print(pairWithoutNames)
            // let ix = pairWithoutNames.first // compile error, we stripped the names
        }
        
        do {
            func tupleMaker() -> (first:Int, second:String) {
                return (1, "Two") // no labels here
            }
            let ix = tupleMaker().first // 1
            print(ix)
        }

        /*
        
        // parameter list in function call is actually a tuple
        // however, new in Swift 2.2, these two calls now get a warning:
        // "Passing 2 arguments to a callee as a single tuple value is deprecated"
        // so is this "feature" going away? If so, you could _store_ as a tuple ...
        // ...but _pass_ as individual arguments
        
        do {
            let tuple = (1,2)
            f(tuple)
        }
        
        do {
            let tuple = (i1:1, i2:2)
            f2(tuple)
        }
        
        do {
//            var tuple = (i1:1, i2:2)
//            f2(tuple) // compile error
        }
 
 */
        
        do { // examples from the dev forums
            
            /*
            
            var array: [(Int, Int)] = []
            
            // OK - literals
            array.append(1, 1)
            
            // OK - let integer
            let int_const = 1
            array.append(int_const, 1)
            
            // OK - let tuple
            let const_tuple: (Int, Int) = (1, 1)
            array.append(const_tuple)
            
            // NOK - var integer
             var int_var = 1
             array.append(int_var, 1)
            
            // NOK - var tuple
             var var_tuple: (Int, Int) = (1, 1)
             array.append(var_tuple)

            */
            
            // However, this changed in Swift 2.0 beta 3:
            // New! You can now write it like a tuple!
            // parentheses in parentheses

            
            var array: [(Int, Int)] = []
            
            
            // OK - literals
            array.append((1,1))
            
            // OK - let integer
            let int_const = 1
            array.append((int_const, 1))
            
            // OK - let tuple
            let const_tuple: (Int, Int) = (1, 1)
            array.append(const_tuple)
            
            // OK - var integer
            var int_var = 1
            array.append((int_var, 1))
            
            // OK - var tuple
            var var_tuple: (Int, Int) = (1, 1)
            array.append(var_tuple)
            
            print(array)

            // shut the compiler up
            int_var = 0
            var_tuple = (0,0)

        }
        
        
    }
    
    
    
}

