

import UIKit

func lend<T> (closure:(T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
		let s2 = """
			Fourscore and seven years ago, our fathers brought forth \
			upon this continent a new nation, conceived in liberty and \
			dedicated to the proposition that all men are created equal.
			"""
        let content2 = NSMutableAttributedString(string:s2, attributes: [
            .font: UIFont(name:"HoeflerText-Black", size:16)!
            ])
        content2.addAttributes([
            .font: UIFont(name:"HoeflerText-Black", size:24)!,
            .expansion: 0.3,
            .kern: -4
        ], range:NSMakeRange(0,1))
        
        content2.addAttribute(.paragraphStyle,
            value: lend {
                (para : NSMutableParagraphStyle) in
                para.headIndent = 10
                para.firstLineHeadIndent = 10
                para.tailIndent = -10
                para.lineBreakMode = .byWordWrapping
                para.alignment = .justified
                para.lineHeightMultiple = 1.2
                para.hyphenationFactor = 1.0
            },
            range:NSMakeRange(0,1))
        
        
        let lab = UILabel() // preferredMaxLayoutWidth is 0
        print(lab.preferredMaxLayoutWidth)
        lab.numberOfLines = 0
        lab.backgroundColor = .yellow
        lab.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lab)
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:
                "H:|-(30)-[v]-(30)-|",
                metrics: nil, views: ["v":lab]),
            NSLayoutConstraint.constraints(withVisualFormat:
                "V:|-(30)-[v]",
                metrics: nil, views: ["v":lab])
            ].flatMap{$0})
        lab.attributedText = content2

    }



}

