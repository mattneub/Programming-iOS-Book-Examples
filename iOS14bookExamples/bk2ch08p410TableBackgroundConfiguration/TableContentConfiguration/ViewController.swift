

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
        self.tableView.register(MyCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.rowHeight = 50
        // self.tableView.allowsMultipleSelection = true
        self.tableView.tintColor = .red
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    let cellID = "cell"
    var which = 3
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
            config.text = "Hello, world" + " " + String(indexPath.row)
            config.textProperties.alignment = .center
            cell.contentConfiguration = config
//            let bv = UIView()
//            bv.backgroundColor = .red
//            cell.selectedBackgroundView = bv
//            let b2 = UIView()
//            b2.backgroundColor = .green
//            cell.multipleSelectionBackgroundView = b2
//            cell.selectionStyle = .none
            var b = UIBackgroundConfiguration.listPlainCell()
            // cannot use both background color and background color transformer
            // b.backgroundColor = .red
            // b.backgroundColor = nil // uses the tint color!
            b.customView = UIImageView(image: UIImage(named: "linen"))
            b.backgroundColorTransformer = UIConfigurationColorTransformer { [weak cell] c in
                if let state = cell?.configurationState {
                    if state.isSelected || state.isHighlighted {
                        return .gray
                    }
                }
                return .blue
            }
//            b.strokeWidth = 2
//            b.strokeColor = .black
            cell.backgroundConfiguration = b
            // makes no difference for background configurations!
            // cell.automaticallyUpdatesContentConfiguration = false
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

class MyCell: UITableViewCell {
    override func updateConfiguration(using state: UICellConfigurationState) {
        defer { super.updateConfiguration(using:state) }
        guard let cv = self.backgroundConfiguration?.customView else { return }
        if state.isSelected || state.isHighlighted {
            if cv.subviews.count == 0 {
                let sel = UIView()
                sel.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
                sel.frame = cv.bounds
                sel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                cv.addSubview(sel)
            }
        } else {
            cv.subviews.first?.removeFromSuperview()
        }
    }
}


