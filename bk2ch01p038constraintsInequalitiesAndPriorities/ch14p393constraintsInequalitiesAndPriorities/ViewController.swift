
import UIKit

func dictionaryOfNames(arr:UIView...) -> [String:UIView] {
    var d = [String:UIView]()
    for (ix,v) in arr.enumerate() {
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
        
        self.lab1.translatesAutoresizingMaskIntoConstraints = false
        self.lab2.translatesAutoresizingMaskIntoConstraints = false
        
        let d = dictionaryOfNames(lab1,lab2)
        
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-20-[v1]", options: [], metrics: nil, views: d),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-20-[v2]", options: [], metrics: nil, views: d),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-20-[v1]", options: [], metrics: nil, views: d),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[v2]-20-|", options: [], metrics: nil, views: d),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[v1(>=100)]-(>=20)-[v2(>=100)]", options: [], metrics: nil, views: d)
            ].flatten().map{$0})
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
        
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false
        
        let d2 = dictionaryOfNames(button, label)
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[v1]-(112)-|", options: [], metrics: nil, views: d2),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-(>=10)-[v2]-[v1]-(>=10)-|",
                options: NSLayoutFormatOptions.AlignAllBaseline,
                metrics: nil, views: d2)
            ].flatten().map{$0})
        
        let con = button.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
        con.priority = 700 // try commenting this out to see the difference in behavior
        NSLayoutConstraint.activateConstraints([con])


        
    }
    
    
    
}
