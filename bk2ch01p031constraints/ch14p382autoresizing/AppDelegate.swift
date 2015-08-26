import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func dictionaryOfNames(arr:UIView...) -> [String:UIView] {
    var d = [String:UIView]()
    for (ix,v) in arr.enumerate() {
        d["v\(ix+1)"] = v
    }
    return d
}

extension NSLayoutConstraint {
    class func reportAmbiguity (var v:UIView?) {
        if v == nil {
            v = UIApplication.sharedApplication().keyWindow
        }
        for vv in v!.subviews {
            print("\(vv) \(vv.hasAmbiguousLayout())")
            if vv.subviews.count > 0 {
                self.reportAmbiguity(vv)
            }
        }
    }
    class func listConstraints (var v:UIView?) {
        if v == nil {
            v = UIApplication.sharedApplication().keyWindow
        }
        for vv in v!.subviews {
            let arr1 = vv.constraintsAffectingLayoutForAxis(.Horizontal)
            let arr2 = vv.constraintsAffectingLayoutForAxis(.Vertical)
            NSLog("\n\n%@\nH: %@\nV:%@", vv, arr1, arr2);
            if vv.subviews.count > 0 {
                self.listConstraints(vv)
            }
        }
    }
}

@UIApplicationMain class AppDelegate : UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow()
        
        self.window!.rootViewController = UIViewController()
        let mainview = self.window!.rootViewController!.view
        
        let v1 = UIView(frame:CGRectMake(100, 111, 132, 194))
        v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        let v2 = UIView()
        v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
        let v3 = UIView()
        v3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        // v3.layer.setValue("littleRedSquare", forKey:"identifier")
        
        mainview.addSubview(v1)
        v1.addSubview(v2)
        v1.addSubview(v3)
        
        v2.translatesAutoresizingMaskIntoConstraints = false
        v3.translatesAutoresizingMaskIntoConstraints = false
        
        var which : Int {return 3}
        switch which {
        case 1:
            // the old way, and this is the last time I'm going to show this
            v1.addConstraint(
                NSLayoutConstraint(item: v2,
                    attribute: .Leading,
                    relatedBy: .Equal,
                    toItem: v1,
                    attribute: .Leading,
                    multiplier: 1, constant: 0)
            )
            v1.addConstraint(
                NSLayoutConstraint(item: v2,
                    attribute: .Trailing,
                    relatedBy: .Equal,
                    toItem: v1,
                    attribute: .Trailing,
                    multiplier: 1, constant: 0)
            )
            v1.addConstraint(
                NSLayoutConstraint(item: v2,
                    attribute: .Top,
                    relatedBy: .Equal,
                    toItem: v1,
                    attribute: .Top,
                    multiplier: 1, constant: 0)
            )
            v2.addConstraint(
                NSLayoutConstraint(item: v2,
                    attribute: .Height,
                    relatedBy: .Equal,
                    toItem: nil,
                    attribute: .NotAnAttribute,
                    multiplier: 1, constant: 10)
            )
            v3.addConstraint(
                NSLayoutConstraint(item: v3,
                    attribute: .Width,
                    relatedBy: .Equal,
                    toItem: nil,
                    attribute: .NotAnAttribute,
                    multiplier: 1, constant: 20)
            )
            v3.addConstraint(
                NSLayoutConstraint(item: v3,
                    attribute: .Height,
                    relatedBy: .Equal,
                    toItem: nil,
                    attribute: .NotAnAttribute,
                    multiplier: 1, constant: 20)
            )
            v1.addConstraint(
                NSLayoutConstraint(item: v3,
                    attribute: .Trailing,
                    relatedBy: .Equal,
                    toItem: v1,
                    attribute: .Trailing,
                    multiplier: 1, constant: 0)
            )
            v1.addConstraint(
                NSLayoutConstraint(item: v3,
                    attribute: .Bottom,
                    relatedBy: .Equal,
                    toItem: v1,
                    attribute: .Bottom,
                    multiplier: 1, constant: 0)
            )
        case 2: // new API in iOS 9 for making constraints individually
            // and we should now be activating constraints, not adding them...
            // to a specific view
            // whereever possible, activate all the constraints at once
            NSLayoutConstraint.activateConstraints([
                v2.leadingAnchor.constraintEqualToAnchor(v1.leadingAnchor),
                v2.trailingAnchor.constraintEqualToAnchor(v1.trailingAnchor),
                v2.topAnchor.constraintEqualToAnchor(v1.topAnchor),
                v2.heightAnchor.constraintEqualToConstant(10),
                v3.widthAnchor.constraintEqualToConstant(20),
                v3.heightAnchor.constraintEqualToConstant(20),
                v3.trailingAnchor.constraintEqualToAnchor(v1.trailingAnchor),
                v3.bottomAnchor.constraintEqualToAnchor(v1.bottomAnchor)
            ])

        case 3:
            
            // NSDictionaryOfVariableBindings(v2,v3) // it's a macro, no macros in Swift
            
            // let d = ["v2":v2,"v3":v3]
            // okay, that's boring...
            // let's write our own Swift NSDictionaryOfVariableBindings substitute (sort of)
            let d = dictionaryOfNames(v1,v2,v3)
            NSLayoutConstraint.activateConstraints([
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "H:|[v2]|", options: [], metrics: nil, views: d),
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:|[v2(10)]", options: [], metrics: nil, views: d),
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "H:[v3(20)]|", options: [], metrics: nil, views: d),
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:[v3(20)]|", options: [], metrics: nil, views: d),
                // uncomment me to form a conflict
//                NSLayoutConstraint.constraintsWithVisualFormat(
//                    "V:[v3(10)]|", options: [], metrics: nil, views: d),
                ].flatten().map{$0})
        default: break
        }
        
        delay(2) {
            v1.bounds.size.width += 40
            v1.bounds.size.height -= 50
        }
        
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("here") // for debugging
    }
    
}
