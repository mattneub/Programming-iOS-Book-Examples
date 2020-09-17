

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
        label.highlightedTextColor = .white
        // that works, so it is not an example of why you'd need to implement updatedForState
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
        if let state = state as? UICellConfigurationState {
            print(state.isSelected, state.isHighlighted, state.traitCollection)
        }
        return self
    }
}


class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.rowHeight = 50
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    let cellID = "cell"
    var which = 2
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        switch which {
        case 1:
            var label = cell.contentView.subviews.first as? UILabel
            if label == nil {
                label = UILabel()
                cell.contentView.addSubview(label!)
                label?.textAlignment = .center
                label?.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    label!.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
                    label!.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10),
                    label!.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                    label!.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                ])
            }
            label?.text = "Hello, world"
        case 2:
            var config = MyContentConfiguration()
            config.text = "Hello, world"
            cell.contentConfiguration = config
        case 3:
            var config = cell.defaultContentConfiguration()
            config.text = "Hello, world"
            config.textProperties.alignment = .center
            cell.contentConfiguration = config
        default: break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at:indexPath, animated:false)
            return nil
        }
        return indexPath
    }
}

