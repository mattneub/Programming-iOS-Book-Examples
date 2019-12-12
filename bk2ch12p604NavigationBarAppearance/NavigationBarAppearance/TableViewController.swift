

import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}
extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}


func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar = self.navigationController!.navigationBar
        bar.prefersLargeTitles = true
        // bar.isTranslucent = false // terrible things happen, leave this alone I think
        // bar.barStyle = .black // this no longer has any effect on the status bar...
        // bar.barTintColor = .red
        // return
        // ...unless you do it and _stop_
        // as soon as you apply a UIBarAppearance, that effect goes away
        
        let app = UINavigationBarAppearance() // I do not understand what the `idiom:` initializer is for
        
        app.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        let r = UIGraphicsImageRenderer(size:CGSize(width: 1, height: 3))
        app.shadowImage = r.image {
            ctx in
            ctx.cgContext.setFillColor(UIColor.orange.cgColor)
            ctx.fill(CGRect(x: 0, y: 0, width: 1, height: 3))
        }
        app.shadowColor = .green
        bar.standardAppearance = app

        // appearance is copied, so we can go on to reuse it
        app.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        bar.compactAppearance = app
        
        app.backgroundColor = UIColor.orange.withAlphaComponent(0.2)
        bar.scrollEdgeAppearance = app
        
        //========
        
        // button appearance - this is such a clean, easy way to talk!
        // I wish they had done this for individual bar button item features as well!!!!
        do {
            let r = UIGraphicsImageRenderer(size: CGSize(40,30))
            let im = r.image { ctx in
                let con = ctx.cgContext
                con.setFillColor(UIColor.white.cgColor)
                ctx.fill(CGRect(0,0,40,30))
            }
            bar.standardAppearance.buttonAppearance.normal.backgroundImage = im
            bar.compactAppearance?.buttonAppearance.normal.backgroundImage = im
            bar.scrollEdgeAppearance?.buttonAppearance.normal.backgroundImage = im
            let im2 = r.image { ctx in
                let con = ctx.cgContext
                con.setFillColor(UIColor.yellow.cgColor)
                ctx.fill(CGRect(0,0,40,30))
            }
            // proving that individual button feature overrides appearance-based feature
            self.navigationItem.rightBarButtonItem?.setBackgroundImage(im, for: .highlighted, barMetrics: .default)
            bar.standardAppearance.buttonAppearance.highlighted.backgroundImage = im2
            bar.compactAppearance?.buttonAppearance.highlighted.backgroundImage = im2
            bar.scrollEdgeAppearance?.buttonAppearance.highlighted.backgroundImage = im2
            
            // how to cancel these changes from the back button
            let none = UIImage()
            bar.standardAppearance.backButtonAppearance.normal.backgroundImage = none
            bar.compactAppearance?.backButtonAppearance.normal.backgroundImage = none
            bar.scrollEdgeAppearance?.backButtonAppearance.normal.backgroundImage = none

        }
        
        // ==========
        
        // back button chevron and mask
        let sz = CGSize(20,20)
        let arrow = UIImage(systemName:"arrowtriangle.left")!
        let indic =
            UIGraphicsImageRenderer(size:sz).image { ctx in
                arrow.draw(in:CGRect(0,0,20,20)) // indicator is arrow
        }
        let indicmask =
            UIGraphicsImageRenderer(size:sz).image { ctx in
                ctx.fill(CGRect(0,0,20,20)) // mask is entire image
            }
        // but before iOS 13.3 it's backwards! so reverse them
        if #available(iOS 13.3, *) {
            print("normal")
            bar.standardAppearance.setBackIndicatorImage(indic, transitionMaskImage: indicmask)
        } else {
            print("reversed")
            bar.standardAppearance.setBackIndicatorImage(indicmask, transitionMaskImage: indic)
        }
        
        // =========
        
        // title
        bar.standardAppearance.titleTextAttributes = [
            .font: UIFont(name:"Chalkduster", size:20)!,
            .foregroundColor: UIColor.black
        ]
        
        // bar.tintColor = .black // showing how to tint the back indicator

        // =========
        
        // tab bar
        
        let tb = self.tabBarController!.tabBar
        let tbapp = UITabBarAppearance() // NB you must _create_ the appearance, not just configure it
        tbapp.stackedItemPositioning = .centered
        tbapp.stackedItemSpacing = 0
        tbapp.stackedItemWidth = 35
        tbapp.selectionIndicatorImage = UIImage(systemName:"checkmark")! // not working
        tbapp.selectionIndicatorTintColor = .orange
        tb.standardAppearance = tbapp
//        tb.selectionIndicatorImage = UIImage(systemName:"checkmark")! // working
//        tb.selectedImageTintColor = .orange // deprecated but it does work
        
        self.tabBarItem?.standardAppearance = tbapp // not working

        // ruins the stack appearance until _after_ we rotate once and back
        tb.standardAppearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [
            .font : UIFont(name:"Georgia", size:14)!,
            .foregroundColor : UIColor.red
        ]
        tb.standardAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .font : UIFont(name:"Georgia", size:14)!,
            .foregroundColor : UIColor.red
        ]
        delay(0.1) {
            tb.setNeedsLayout()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = indexPath.row.isMultiple(of:2) ?
            .yellow : .white
        return cell
    }

}
