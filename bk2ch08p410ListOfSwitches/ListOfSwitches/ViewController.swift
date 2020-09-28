
import UIKit

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
protocol SwitchListener : AnyObject {
    func switchChangedTo(_:Bool, sender:UIView)
}
struct Config: UIContentConfiguration {
    var isOn = false
    weak var delegate : SwitchListener?
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
        sw.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(sw)
        sw.center = CGPoint(x:self.bounds.midX, y:self.bounds.midY)
        sw.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        sw.addAction(UIAction { action in
            if let sender = action.sender as? UISwitch {
                (configuration as? Config)?.delegate?.switchChangedTo(sender.isOn, sender:sender)
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
        config.delegate = self
        cell.contentConfiguration = config
        return cell
    }
    deinit {
        print("farewell") // check memory management
    }
}
extension ViewController : SwitchListener {
    func switchChangedTo(_ newValue: Bool, sender: UIView) {
        if let cell = sender.next(ofType: UITableViewCell.self) {
            if let ip = self.tableView.indexPath(for: cell) {
                self.list[ip.row] = newValue
            }
        }
    }
}


