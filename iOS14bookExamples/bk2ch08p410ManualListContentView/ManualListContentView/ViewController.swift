

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var stack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for pep in ["Manny", "Moe", "Jack"] {
            var config = UIListContentConfiguration.cell()
            config.text = pep
            config.image = UIImage(named: pep)
            let v = UIListContentView(configuration: config)
            self.stack.addArrangedSubview(v)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.stack.addGestureRecognizer(tap)
    }

    var currentFavorite = "" {
        didSet {
            print("Your favorite is", currentFavorite)
        }
    }
    @objc func didTap(_ gr: UIGestureRecognizer) {
        guard let v = gr.view, gr.state == .ended else { return }
        if let pep = v.hitTest(gr.location(in: v), with: nil) as? UIListContentView {
            if let config = pep.configuration as? UIListContentConfiguration {
                if let which = config.text {
                    self.currentFavorite = which
                    self.checkFavorite()
                }
            }
        }
    }
    
    func checkmarkView() -> UIImageView {
        let iv = UIImageView(image: UIImage(systemName: "checkmark")!)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .label
        iv.tag = 100
        return iv
    }
    
    func checkFavorite() {
        for pep in self.stack.arrangedSubviews as! [UIListContentView] {
            if let check = pep.viewWithTag(100) { check.removeFromSuperview() }
            if let config = pep.configuration as? UIListContentConfiguration {
                if let which = config.text, which == self.currentFavorite {
                    let iv = self.checkmarkView()
                    pep.addSubview(iv)
                    if let text = pep.textLayoutGuide {
                        iv.leadingAnchor.constraint(equalTo: text.trailingAnchor, constant: 20).isActive = true
                        iv.centerYAnchor.constraint(equalTo: text.centerYAnchor).isActive = true
                    }
                }
            }
        }
    }

}

