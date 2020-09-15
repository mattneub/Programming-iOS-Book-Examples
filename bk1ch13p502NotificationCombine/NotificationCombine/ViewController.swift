

import UIKit
import Combine

class Card : UIView {
    @IBInspectable var name : NSString = ""
    static let tapped = Notification.Name("tapped")
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        let t = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(t)
    }
    @objc func tapped() {
        NotificationCenter.default.post(name: Self.tapped, object: self)
    }
}

class MySwitch : UISwitch {
    @Published var isOnPublisher = false
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.isOnPublisher = self.isOn
        let action = UIAction {[unowned self] _ in
            self.isOnPublisher = self.isOn
        }
        self.addAction(action, for: .primaryActionTriggered)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var mySwitch : MySwitch!
    
    let cardTappedCardNamePublisher =
        NotificationCenter.default.publisher(for: Card.tapped)
        .compactMap {$0.object as? Card}
        .map {$0.name}
    // .eraseToAnyPublisher()
    // lazy var switchOnPublisher = mySwitch.$isOnPublisher
    //.eraseToAnyPublisher()
    // lazy var pub = self.mySwitch.publisher(for: \.isOn) // KVO
    lazy var combination =
        Publishers.CombineLatest(
            self.cardTappedCardNamePublisher,
            self.mySwitch.$isOnPublisher
        )
        .scan(("",true,true)) { ($1.0, $0.2, $1.1) }
        .filter { $0.1 && $0.2 }
        .map { $0.0 }
        .eraseToAnyPublisher()
    
    var which = 2
    var storage = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch which {
        case 0:
            NotificationCenter.default.addObserver(self, selector: #selector(cardTapped), name: Card.tapped, object: nil)
        case 1:
            let sink = self.cardTappedCardNamePublisher.sink {
                print($0)
            }
            sink.store(in: &self.storage)
        case 2:
            let sink = self.mySwitch.$isOnPublisher.sink {
                print($0)
            }
            sink.store(in: &self.storage)
        case 3:
            let sink = self.combination.sink {
                print($0)
            }
            sink.store(in: &self.storage)
        default:break
        }
        
    }
    @objc func cardTapped(_ n:Notification) {
        if let card = n.object as? Card {
            let name = card.name
            print(name)
        }
    }
    deinit {
        print("farewell from view controller")
    }
    
}

