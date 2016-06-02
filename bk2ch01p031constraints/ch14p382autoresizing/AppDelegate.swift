import UIKit

func delay(_ delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func dictionaryOfNames(_ arr:UIView...) -> [String:UIView] {
    var d = [String:UIView]()
    for (ix,v) in arr.enumerated() {
        d["v\(ix+1)"] = v
    }
    return d
}

extension NSLayoutConstraint {
    class func reportAmbiguity (_ v:UIView?) {
        var v = v
        if v == nil {
            v = UIApplication.shared().keyWindow
        }
        for vv in v!.subviews {
            print("\(vv) \(vv.hasAmbiguousLayout())")
            if vv.subviews.count > 0 {
                self.reportAmbiguity(vv)
            }
        }
    }
    class func listConstraints (_ v:UIView?) {
        var v = v
        if v == nil {
            v = UIApplication.shared().keyWindow
        }
        for vv in v!.subviews {
            let arr1 = vv.constraintsAffectingLayout(for:.horizontal)
            let arr2 = vv.constraintsAffectingLayout(for:.vertical)
            NSLog("\n\n%@\nH: %@\nV:%@", vv, arr1 as NSArray, arr2 as NSArray);
            if vv.subviews.count > 0 {
                self.listConstraints(vv)
            }
        }
    }
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}


@UIApplicationMain class AppDelegate : UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow()
        
        self.window!.rootViewController = UIViewController()
        let mainview = self.window!.rootViewController!.view
        
        let v1 = UIView(frame:CGRect(100, 111, 132, 194))
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
        
        var which : Int {return 2}
        switch which {
        case 1:
            // the old way, and this is the last time I'm going to show this
            v1.addConstraint(
                NSLayoutConstraint(item: v2,
                    attribute: .leading,
                    relatedBy: .equal,
                    toItem: v1,
                    attribute: .leading,
                    multiplier: 1, constant: 0)
            )
            v1.addConstraint(
                NSLayoutConstraint(item: v2,
                    attribute: .trailing,
                    relatedBy: .equal,
                    toItem: v1,
                    attribute: .trailing,
                    multiplier: 1, constant: 0)
            )
            v1.addConstraint(
                NSLayoutConstraint(item: v2,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: v1,
                    attribute: .top,
                    multiplier: 1, constant: 0)
            )
            v2.addConstraint(
                NSLayoutConstraint(item: v2,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1, constant: 10)
            )
            v3.addConstraint(
                NSLayoutConstraint(item: v3,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1, constant: 20)
            )
            v3.addConstraint(
                NSLayoutConstraint(item: v3,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1, constant: 20)
            )
            v1.addConstraint(
                NSLayoutConstraint(item: v3,
                    attribute: .trailing,
                    relatedBy: .equal,
                    toItem: v1,
                    attribute: .trailing,
                    multiplier: 1, constant: 0)
            )
            v1.addConstraint(
                NSLayoutConstraint(item: v3,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: v1,
                    attribute: .bottom,
                    multiplier: 1, constant: 0)
            )
        case 2: // new API in iOS 9 for making constraints individually
            // and we should now be activating constraints, not adding them...
            // to a specific view
            // whereever possible, activate all the constraints at once
            NSLayoutConstraint.activate([
                    v2.leadingAnchor.constraintEqual(to:v1.leadingAnchor),
                    v2.trailingAnchor.constraintEqual(to:v1.trailingAnchor),
                    v2.topAnchor.constraintEqual(to:v1.topAnchor),
                    v2.heightAnchor.constraintEqual(toConstant:10),
                    v3.widthAnchor.constraintEqual(toConstant:20),
                    v3.heightAnchor.constraintEqual(toConstant:20),
                    v3.trailingAnchor.constraintEqual(to:v1.trailingAnchor),
                    v3.bottomAnchor.constraintEqual(to:v1.bottomAnchor)
                ])
            
        case 3:
            
            // NSDictionaryOfVariableBindings(v2,v3) // it's a macro, no macros in Swift
            
            // let d = ["v2":v2,"v3":v3]
            // okay, that's boring...
            // let's write our own Swift NSDictionaryOfVariableBindings substitute (sort of)
            let d = dictionaryOfNames(v1,v2,v3)
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat:
                    "H:|[v2]|", metrics: nil, views: d),
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:|[v2(10)]", metrics: nil, views: d),
                NSLayoutConstraint.constraints(withVisualFormat:
                    "H:[v3(20)]|", metrics: nil, views: d),
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:[v3(20)]|", metrics: nil, views: d),
                // uncomment me to form a conflict
//                NSLayoutConstraint.constraints(withVisualFormat:
//                    "V:[v3(10)]|", metrics: nil, views: d),
                ].flatten().map{$0})
        default: break
        }
        
        delay(2) {
            v1.bounds.size.width += 40
            v1.bounds.size.height -= 50
        }
        
        self.window!.backgroundColor = UIColor.white()
        self.window!.makeKeyAndVisible()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("here") // for debugging
    }
    
}
