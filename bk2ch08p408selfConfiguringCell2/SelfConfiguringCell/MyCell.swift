

import UIKit

class MyCell : UITableViewCell {
    @IBOutlet var theLabel : UILabel!
    @IBOutlet var theImageView : UIImageView!

    class MyContentView: UIView & UIContentView {
        var configuration: UIContentConfiguration
        init(configuration: UIContentConfiguration) {
            self.configuration = configuration
            super.init(frame: .zero)
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    struct Configuration : UIContentConfiguration {
        let text: String
        let image: UIImage
        // this view will automatically _replace_ the cell's `contentView`
        func makeContentView() -> UIView & UIContentView {
            let lab = UILabel()
            lab.numberOfLines = 2
            lab.font = UIFont(name: "Helvetica-Bold", size: 16)
            lab.text = self.text
            let iv = UIImageView()
            iv.contentMode = .center
            let im = self.image
            let r = UIGraphicsImageRenderer(size:CGSize(36,36), format:im.imageRendererFormat)
            let im2 = r.image {
                _ in im.draw(in:CGRect(0,0,36,36))
            }
            iv.image = im2
            // construct the view
            let c = MyContentView(configuration: self)
            c.addSubview(lab)
            c.addSubview(iv)
            lab.translatesAutoresizingMaskIntoConstraints = false
            iv.translatesAutoresizingMaskIntoConstraints = false
            lab.leadingAnchor.constraint(equalTo: c.leadingAnchor, constant:15).isActive = true
            lab.topAnchor.constraint(equalTo: c.topAnchor).isActive = true
            lab.bottomAnchor.constraint(equalTo: c.bottomAnchor).isActive = true
            iv.leadingAnchor.constraint(equalTo: lab.trailingAnchor, constant: 15).isActive = true
            iv.trailingAnchor.constraint(equalTo: c.trailingAnchor, constant: -15).isActive = true
            iv.centerYAnchor.constraint(equalTo: c.centerYAnchor).isActive = true
            iv.widthAnchor.constraint(equalTo: iv.heightAnchor).isActive = true
            return c
        }
        func updated(for state: UIConfigurationState) -> MyCell.Configuration {
            print("updating for state", state)
            return self
        }
    }
}

