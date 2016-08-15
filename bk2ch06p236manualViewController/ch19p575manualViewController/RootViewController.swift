

import UIKit



class RootViewController: UIViewController {
    
    let which = 1
    
    override func loadView() {
        let v = UIView()
        v.backgroundColor = .green
        self.view = v
        let label = UILabel()
        v.addSubview(label)
        label.text = "Hello, World!"

        switch which {
        case 1:
            label.autoresizingMask = [
                .flexibleTopMargin,
                .flexibleLeftMargin,
                .flexibleBottomMargin,
                .flexibleRightMargin]
            label.sizeToFit()
            label.center = CGPoint(x:v.bounds.midX, y:v.bounds.midY)
            label.frame = label.frame.integral

        case 2:
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo:self.view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo:self.view.centerYAnchor),
                ])
        default: break
        }
    }

}
