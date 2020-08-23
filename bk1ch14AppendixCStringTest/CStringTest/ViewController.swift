

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let s = "hello"
        takeCString("hello")
        takeCString(s)
        //
        let arrayOfCChar : [CChar]? = s.cString(using: .utf8)
        takeCString(arrayOfCChar!)
        //
        let contiguousArrayOfCChar : ContiguousArray<CChar> = s.utf8CString
        contiguousArrayOfCChar.withUnsafeBufferPointer { ptr -> Void in
            takeCString(ptr.baseAddress!)
        }
        
        s.withCString { ptr -> Void in
            takeCString(ptr)
        }
        
        let unsafePointerToInt8 : UnsafePointer<Int8>? = (s as NSString).utf8String
        takeCString(unsafePointerToInt8!) // probably not a good idea
        
        let result : UnsafePointer<Int8> = returnCString()
        let resultString : String = String(cString: result)
        print(resultString)


    }


}

