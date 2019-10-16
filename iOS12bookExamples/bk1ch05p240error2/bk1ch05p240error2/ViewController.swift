

import UIKit

class Dog {}
class NoisyDog : Dog {}

/*
I don't deal in the book with the question when one function type can be substituted for another.
But it's nice to have a test case lying around...
As nomothetis has explained http://nomothetis.svbtle.com/type-variance-in-swift :
"functions are covariant with their return type and contravariant with their parameter types"
*/


class ViewController: UIViewController {
    
    typealias VoidVoidThrower = () throws -> ()
    typealias VoidVoid = () -> ()
    
    typealias DogTaker = (Dog) -> ()
    typealias NoisyDogTaker = (NoisyDog) -> ()
    
    typealias DogMaker = () -> Dog
    typealias NoisyDogMaker = () -> NoisyDog

    func test() {
        
        func f1 (d:Dog) -> () {}
        func f2 (d:NoisyDog) -> () {}
        var v1 : DogTaker
        var v2 : NoisyDogTaker
        
        v1 = f1
        v2 = f2
        
        // v1 = f2 // not legal!!
        v2 = f1 // legal!!
        
        _ = v1
        _ = v2

    }
    
    func test2() {
        
        func f1 () -> Dog { return Dog() }
        func f2 () -> NoisyDog { return NoisyDog() }
        var v1 : DogMaker
        var v2 : NoisyDogMaker
        
        v1 = f1
        v2 = f2
        
        v1 = f2 // legal
        // v2 = f1 // not legal
        
        _ = v1
        _ = v2
        
    }
    
    func test3() {
        
        func f1 () throws -> () {}
        func f2 () -> () {}
        var v1 : VoidVoidThrower
        var v2 : VoidVoid
        
        v1 = f1
        v2 = f2
        
        v1 = f2 // legal
        // v2 = f1 // not legal
        
        _ = v1
        _ = v2

    }




}

