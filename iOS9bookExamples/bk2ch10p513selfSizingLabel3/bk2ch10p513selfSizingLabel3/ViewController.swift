

import UIKit

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let s2 = "Fourscore and seven years ago, our fathers brought forth " +
            "upon this continent a new nation, conceived in liberty and dedicated " +
        "to the proposition that all men are created equal."
        let content2 = NSMutableAttributedString(string:s2, attributes: [
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:16)!
            ])
        content2.addAttributes([
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:24)!,
            NSExpansionAttributeName: 0.3,
            NSKernAttributeName: -4 // negative kerning bug fixed in iOS 8, broken again in iOS 8.3
            ], range:NSMakeRange(0,1))
        
        content2.addAttribute(NSParagraphStyleAttributeName,
            value: lend {
                (para : NSMutableParagraphStyle) in
                para.headIndent = 10
                para.firstLineHeadIndent = 10
                para.tailIndent = -10
                para.lineBreakMode = .ByWordWrapping
                para.alignment = .Justified
                para.lineHeightMultiple = 1.2
                para.hyphenationFactor = 1.0
            },
            range:NSMakeRange(0,1))
        
        
        let lab = UILabel() // preferredMaxLayoutWidth is 0
        print(lab.preferredMaxLayoutWidth)
        lab.numberOfLines = 0
        lab.backgroundColor = UIColor.yellowColor()
        lab.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lab)
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-(30)-[v]-(30)-|",
                options: [], metrics: nil, views: ["v":lab]),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-(30)-[v]",
                options: [], metrics: nil, views: ["v":lab])
            ].flatten().map{$0})
        lab.attributedText = content2

    }



}

