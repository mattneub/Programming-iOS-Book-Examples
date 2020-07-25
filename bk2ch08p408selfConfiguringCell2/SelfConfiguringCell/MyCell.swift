

import UIKit

class MyCell : UITableViewCell {
    @IBOutlet var theLabel : UILabel!
    @IBOutlet var theImageView : UIImageView!

    class MyContentView: UIView & UIContentView {
        var configuration: UIContentConfiguration
        let lab : UILabel
        let iv : UIImageView
        init(configuration: UIContentConfiguration) {
            self.configuration = configuration
            let lab = UILabel()
            self.lab = lab
            let iv = UIImageView()
            self.iv = iv
            super.init(frame: .zero)
            iv.contentMode = .center
            self.addSubview(lab)
            self.addSubview(iv)
            lab.translatesAutoresizingMaskIntoConstraints = false
            iv.translatesAutoresizingMaskIntoConstraints = false
            lab.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:15).isActive = true
            lab.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            lab.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            lab.numberOfLines = 2
            lab.font = UIFont(name: "Helvetica-Bold", size: 16)
            iv.leadingAnchor.constraint(equalTo: lab.trailingAnchor, constant: 15).isActive = true
            iv.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
            iv.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            iv.widthAnchor.constraint(equalTo: iv.heightAnchor).isActive = true
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
            let c = MyContentView(configuration: self)
            c.lab.text = self.text
            let im = self.image
            let r = UIGraphicsImageRenderer(size:CGSize(36,36), format:im.imageRendererFormat)
            let im2 = r.image {
                _ in im.draw(in:CGRect(0,0,36,36))
            }
            c.iv.image = im2
            return c
        }
        func updated(for state: UIConfigurationState) -> MyCell.Configuration {
            print("updating for state", state)
            return self
        }
    }
}

