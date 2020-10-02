

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
extension UIResponder {
    func next<T:UIResponder>(ofType: T.Type) -> T? {
        let r = self.next
        if let r = r as? T ?? r?.next(ofType: T.self) {
            return r
        } else {
            return nil
        }
    }
}
struct Config: UIContentConfiguration {
    var isOn = false
    var isOnChanged : ((Bool, UIView) -> Void)?
    func makeContentView() -> UIView & UIContentView {
        return MyContentView(configuration:self)
    }
    func updated(for state: UIConfigurationState) -> Config {
        return self
    }
}
class MyContentView : UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            config()
        }
    }
    let sw = UISwitch()
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame:.zero)
        sw.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sw)
        sw.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        sw.topAnchor.constraint(equalTo: self.topAnchor, constant:10).isActive = true
        sw.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:-10).isActive = true
        sw.addAction(UIAction { action in
            if let sender = action.sender as? UISwitch {
                (configuration as? Config)?.isOnChanged?(sender.isOn, sender)
            }
        }, for: .valueChanged)
        config()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func config() {
        self.sw.isOn = (configuration as? Config)?.isOn ?? false
    }
}
class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet var tableView : UITableView!
    var list = Array(repeating: false, count: 100)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = Config()
        config.isOn = list[indexPath.row]
        config.isOnChanged = { [weak self] isOn, v in
            if let cell = v.next(ofType: UITableViewCell.self) {
                if let ip = self?.tableView.indexPath(for: cell) {
                    self?.list[ip.row] = isOn
                }
            }
        }
        cell.contentConfiguration = config
        return cell
    }
    deinit {
        print("farewell") // check memory management
    }
}

class ViewController2: UIViewController {
    @IBOutlet var tableView : UITableView!
    var datasource : UITableViewDiffableDataSource<String,UUID>!
    var switches = [UUID:Bool]()
    override func viewDidLoad() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.datasource = UITableViewDiffableDataSource<String,UUID>(tableView: self.tableView) { [unowned self] tv, ip, uuid in
            let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: ip)
            var config = Config()
            config.isOn = self.switches[uuid] ?? false
            config.isOnChanged = { isOn, v in
                if let cell = v.next(ofType: UITableViewCell.self) {
                    if let ip = tv.indexPath(for: cell) {
                        if let uuid = self.datasource.itemIdentifier(for: ip) {
                            self.switches[uuid] = isOn
                        }
                    }
                }
            }
            cell.contentConfiguration = config
            return cell
        }
        var snap = NSDiffableDataSourceSnapshot<String,UUID>()
        snap.appendSections(["Dummy"])
        snap.appendItems((1...100).map {_ in
            let uuid = UUID()
            self.switches[uuid] = false
            return uuid
        })
        self.datasource.apply(snap, animatingDifferences: false)
    }
    deinit {
        print("farewell2") // check memory management
    }
}
