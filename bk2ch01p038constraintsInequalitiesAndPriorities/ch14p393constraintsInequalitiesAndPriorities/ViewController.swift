
import UIKit

func dictionaryOfNames(_ arr:UIView...) -> [String:UIView] {
    var d = [String:UIView]()
    for (ix,v) in arr.enumerated() {
        d["v\(ix+1)"] = v
    }
    return d
}


class ViewController : UIViewController {
    
    
    @IBOutlet var lab1 : UILabel!
    @IBOutlet var lab2 : UILabel!
    @IBOutlet var label : UILabel!
    @IBOutlet var button : UIButton!
    
    @IBAction func doWiden(_ sender:AnyObject?) {
        self.lab1.text = self.lab1.text! + "xxxxx"
        self.lab2.text = self.lab2.text! + "xxxxx"
        self.label.text = self.label.text! + "xxxxx"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        self.lab1.translatesAutoresizingMaskIntoConstraints = false
        self.lab2.translatesAutoresizingMaskIntoConstraints = false
        
        let d = dictionaryOfNames(lab1,lab2)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:
                "V:|-20-[v1]", metrics: nil, views: d),
            NSLayoutConstraint.constraints(withVisualFormat:
                "V:|-20-[v2]", metrics: nil, views: d),
            NSLayoutConstraint.constraints(withVisualFormat:
                "H:|-20-[v1]", metrics: nil, views: d),
            NSLayoutConstraint.constraints(withVisualFormat:
                "H:[v2]-20-|", metrics: nil, views: d),
            NSLayoutConstraint.constraints(withVisualFormat:
                "H:[v1(>=100)]-(>=20)-[v2(>=100)]", metrics: nil, views: d)
            ].flatten().map{$0})
        // added width shrinkage limit to both labels, so neither gets driven down to invisibility
        
        // we will be ambiguous when the label texts grow
        // one way to solve: different compression resistance priorities
        
        let p = self.lab2.contentCompressionResistancePriority(for:.horizontal)
        self.lab1.setContentCompressionResistancePriority(p+1, for: .horizontal)
//        println(self.lab1.contentCompressionResistancePriorityForAxis(.Horizontal))
//        println(self.lab2.contentCompressionResistancePriorityForAxis(.Horizontal))
//        println(self.lab1.contentHuggingPriorityForAxis(.Horizontal))
//        println(self.lab2.contentHuggingPriorityForAxis(.Horizontal))

        
        // =====================================
        
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false
        
        let d2 = dictionaryOfNames(button, label)
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:
                "V:[v1]-(112)-|", metrics: nil, views: d2),
            NSLayoutConstraint.constraints(withVisualFormat:
                "H:|-(>=10)-[v2]-[v1]-(>=10)-|",
                options: NSLayoutFormatOptions.alignAllBaseline,
                metrics: nil, views: d2)
            ].flatten().map{$0})
        
        let con = button.centerXAnchor.constraintEqual(to:self.view.centerXAnchor)!
        con.priority = 700 // try commenting this out to see the difference in behavior
        NSLayoutConstraint.activate([con])


        
    }
    
    
    
}
