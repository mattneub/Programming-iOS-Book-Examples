
import UIKit

func dictionaryOfNames(_ arr:UIView...) -> [String:UIView] {
    var d = [String:UIView]()
    for (ix,v) in arr.enumerated() {
        d["v\(ix+1)"] = v
    }
    return d
}

// idea from https://stackoverflow.com/a/57102973/341994
extension NSLayoutConstraint {
    func activate(withIdentifier id: String) {
        (self.identifier, self.isActive) = (id,true)
    }
}


class ViewController : UIViewController {
    
    
    @IBOutlet var lab1 : UILabel!
    @IBOutlet var lab2 : UILabel!
    @IBOutlet var label : UILabel!
    @IBOutlet var button : UIButton!
    
    @IBAction func doWiden(_ sender: Any?) {
        self.lab1.text = self.lab1.text! + "xxxxx"
        self.lab2.text = self.lab2.text! + "xxxxx"
        self.label.text = self.label.text! + "xxxxx"
        print(self.lab1.hasAmbiguousLayout || self.lab2.hasAmbiguousLayout || self.label.hasAmbiguousLayout)
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
            ].flatMap{$0})
        // added width shrinkage limit to both labels, so neither gets driven down to invisibility
        
        // we will be ambiguous when the label texts grow
        // one way to solve: different compression resistance priorities
        
        let p = self.lab2.contentCompressionResistancePriority(for:.horizontal)
        self.lab1.setContentCompressionResistancePriority(p+1, for: .horizontal)
        print(self.lab1.contentCompressionResistancePriority(for: .horizontal))
        print(self.lab2.contentCompressionResistancePriority(for: .horizontal))
        print(self.lab1.contentHuggingPriority(for: .horizontal))
        print(self.lab2.contentHuggingPriority(for: .horizontal))

        
        // =====================================
        
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false
        
        let d2 = dictionaryOfNames(button, label)
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:
                "V:[v1]-(112)-|", metrics: nil, views: d2),
            NSLayoutConstraint.constraints(withVisualFormat:
                "H:|-(>=10)-[v2]-[v1]-(>=10)-|",
                options: .alignAllLastBaseline,
                metrics: nil, views: d2)
            ].flatMap{$0})
        
        let con = button.centerXAnchor.constraint(equalTo:self.view.centerXAnchor)
        // no longer need to say rawValue
        con.priority = UILayoutPriority(700) // try commenting this out to see the difference in behavior
        // no longer need an extension to add to a priority
        let ppppp = con.priority + 8
        NSLayoutConstraint.activate([con])


        
    }
    
    
    
}
