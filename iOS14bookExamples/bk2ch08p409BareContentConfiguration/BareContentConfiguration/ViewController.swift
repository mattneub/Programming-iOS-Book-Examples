

import UIKit

class MyContentView : UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            self.configure(configuration: configuration)
        }
    }
    let label = UILabel()
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame:.zero)
        self.addSubview(self.label)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
        self.configure(configuration: configuration)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? MyContentConfiguration else { return }
        self.label.text = configuration.text
    }
}

struct MyContentConfiguration : UIContentConfiguration {
    var text = ""
    func makeContentView() -> UIView & UIContentView {
        return MyContentView(self)
    }
    func updated(for state: UIConfigurationState) -> MyContentConfiguration {
        print("updated")
        return self
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // test harness
        var config = MyContentConfiguration()
        config.text = "Hello, world"
        let v = MyContentView(config)
        v.frame = CGRect(x: 100, y: 100, width: 200, height: 100)
        v.backgroundColor = .yellow
        self.view.addSubview(v)
    }


}

