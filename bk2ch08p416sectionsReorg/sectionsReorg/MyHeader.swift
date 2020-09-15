
import UIKit

class MyHeader: UITableViewHeaderFooterView {
    struct Configuration {
        let sectionName : String
    }
    func configure(_ configuration: Configuration) {
        self.tintColor = .red
        if self.viewWithTag(1) == nil {
            print("configuring a new header view") // only called about 8 times
            self.backgroundView = UIView()
            self.backgroundView?.backgroundColor = .black
            let lab = UILabel()
            lab.tag = 1
            lab.font = UIFont(name:"Georgia-Bold", size:22)
            lab.textColor = .green
            lab.backgroundColor = .clear
            self.contentView.addSubview(lab)
            let v = UIImageView()
            v.tag = 2
            v.backgroundColor = .black
            v.image = UIImage(named:"us_flag_small.gif")
            self.contentView.addSubview(v)
            lab.translatesAutoresizingMaskIntoConstraints = false
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat:"H:|-5-[lab(25)]-10-[v(40)]",
                                               metrics:nil, views:["v":v, "lab":lab]),
                NSLayoutConstraint.constraints(withVisualFormat:"V:|[v]|",
                                               metrics:nil, views:["v":v]),
                NSLayoutConstraint.constraints(withVisualFormat:"V:|[lab]|",
                                               metrics:nil, views:["lab":lab])
            ].flatMap {$0})
        }
        let lab = self.contentView.viewWithTag(1) as! UILabel
        lab.text = configuration.sectionName
    }
}
