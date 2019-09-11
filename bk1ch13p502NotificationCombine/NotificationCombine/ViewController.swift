

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
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.isOnPublisher = self.isOn
        self.addTarget(self, action: #selector(didChangeOn), for: .valueChanged)
    }
    @Published var isOnPublisher = false
    @objc func didChangeOn() {
        self.isOnPublisher = self.isOn
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var mySwitch : MySwitch!
    
    let cardTappedCardNamePublisher = NotificationCenter.default.publisher(for: Card.tapped)
        .compactMap {$0.object as? Card}
        .map {$0.name}
    //.eraseToAnyPublisher()
    // lazy var switchOnPublisher = mySwitch.$isOnPublisher
    //.eraseToAnyPublisher()
    // lazy var pub = self.mySwitch.publisher(for: \.isOn) // KVO
    lazy var combination =
        Publishers.CombineLatest(
            self.cardTappedCardNamePublisher, self.mySwitch.$isOnPublisher)
                .scan((nil,true)) { $0.1 != $1.1 ? (nil,$1.1) : $1 }
                .filter { $0.1 }
                .compactMap { $0.0 }
                //.eraseToAnyPublisher()
    
    var which = 3
    var sink : AnyCancellable?
    override func viewDidLoad() {
        super.viewDidLoad()

        switch which {
        case 0:
            NotificationCenter.default.addObserver(self, selector: #selector(cardTapped), name: Card.tapped, object: nil)
        case 1:
            let sink = self.cardTappedCardNamePublisher.sink {
                print($0)
            }
            self.sink = sink
        case 2:
            let sink = self.mySwitch.$isOnPublisher.sink {
                print($0)
            }
            self.sink = sink
        case 3:
            let sink = self.combination.sink {
                print($0)
            }
            self.sink = sink
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

