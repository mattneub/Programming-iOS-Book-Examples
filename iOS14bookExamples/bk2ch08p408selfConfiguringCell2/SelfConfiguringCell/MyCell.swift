

import UIKit

class MyCell : UITableViewCell {
    @IBOutlet var theLabel : UILabel!
    @IBOutlet var theImageView : UIImageView!

    class MyContentView: UIView, UIContentView {
        var configuration: UIContentConfiguration {
            didSet {
                self.configure()
            }
        }
        private let lab = UILabel()
        private let iv = UIImageView()
        init(configuration: UIContentConfiguration) {
            self.configuration = configuration
            super.init(frame: .zero)
            self.lab.numberOfLines = 2
            self.lab.font = UIFont(name: "Helvetica-Bold", size: 16)
            self.iv.contentMode = .center
            // construct the view
            self.addSubview(self.lab)
            self.addSubview(self.iv)
            self.lab.translatesAutoresizingMaskIntoConstraints = false
            self.iv.translatesAutoresizingMaskIntoConstraints = false
            self.lab.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:15).isActive = true
            self.lab.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            self.lab.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            self.iv.leadingAnchor.constraint(equalTo: self.lab.trailingAnchor, constant: 15).isActive = true
            self.iv.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
            self.iv.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            self.iv.widthAnchor.constraint(equalTo: self.iv.heightAnchor).isActive = true
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        private func configure() {
            guard let config = self.configuration as? Configuration else { return }
            self.lab.text = config.text
            let im = config.image
            let r = UIGraphicsImageRenderer(size:CGSize(36,36), format:im.imageRendererFormat)
            let im2 = r.image {
                _ in im.draw(in:CGRect(0,0,36,36))
            }
            self.iv.image = im2
        }
    }
    struct Configuration : UIContentConfiguration {
        let text: String
        let image: UIImage
        // this view will automatically _replace_ the cell's `contentView`
        func makeContentView() -> UIView & UIContentView {
            return MyContentView(configuration: self)
        }
        func updated(for state: UIConfigurationState) -> Self {
            // we have no state-based changes, just return self
            return self
        }
    }
}

