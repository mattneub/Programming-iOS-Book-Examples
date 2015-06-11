
import UIKit

func dictionaryOfNames(arr:UIView...) -> [String:UIView] {
    var d = [String:UIView]()
    for (ix,v) in enumerate(arr) {
        d["v\(ix+1)"] = v
    }
    return d
}


class ViewController : UIViewController {
    
    
    @IBOutlet var lab1 : UILabel!
    @IBOutlet var lab2 : UILabel!
    @IBOutlet var label : UILabel!
    @IBOutlet var button : UIButton!
    
    @IBAction func doWiden(sender:AnyObject?) {
        self.lab1.text = self.lab1.text! + "xxxxx"
        self.lab2.text = self.lab2.text! + "xxxxx"
        self.label.text = self.label.text! + "xxxxx"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        
        self.lab1.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.lab2.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let d = dictionaryOfNames(lab1,lab2)
        
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-20-[v1]", options: nil, metrics: nil, views: d)
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-20-[v2]", options: nil, metrics: nil, views: d)
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-20-[v1]", options: nil, metrics: nil, views: d)
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[v2]-20-|", options: nil, metrics: nil, views: d)
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[v1(>=20)]-(>=20)-[v2(>=20)]", options: nil, metrics: nil, views: d)
        )
        // added width shrinkage limit to both labels, so neither gets driven down to invisibility
        
        // we will be ambiguous when the label texts grow
        // one way to solve: different compression resistance priorities
        
        let p = self.lab2.contentCompressionResistancePriorityForAxis(.Horizontal)
        self.lab1.setContentCompressionResistancePriority(p+1, forAxis: .Horizontal)
//        println(self.lab1.contentCompressionResistancePriorityForAxis(.Horizontal))
//        println(self.lab2.contentCompressionResistancePriorityForAxis(.Horizontal))
//        println(self.lab1.contentHuggingPriorityForAxis(.Horizontal))
//        println(self.lab2.contentHuggingPriorityForAxis(.Horizontal))

        
        // =====================================
        
        self.button.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.label.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let d2 = dictionaryOfNames(button, label)
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[v1]-(112)-|", options: nil, metrics: nil, views: d2)
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-(>=10)-[v2]-[v1]-(>=10)-|",
                options: NSLayoutFormatOptions.AlignAllBaseline,
                metrics: nil, views: d2)
        )
        let con = NSLayoutConstraint(item: button,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .CenterX,
            multiplier: 1, constant: 0)
        con.priority = 700 // try commenting this out to see the difference in behavior
        self.view.addConstraint(con)


        
    }
    
    
    
}
