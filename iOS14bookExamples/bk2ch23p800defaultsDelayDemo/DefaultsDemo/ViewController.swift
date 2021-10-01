

import UIKit

struct Default {
    static let deck = "deck"
    static let cardsInUse = "cardsinuse"
}


class ViewController: UIViewController {
    
    var deck = Deck()
    var cardsInUse : [Card?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil, queue: nil) {
                _ in
                let arr = self.cardsInUse
                let cardsinusearchive = try! PropertyListEncoder().encode(arr)
                UserDefaults.standard.set(cardsinusearchive, forKey: Default.cardsInUse)
                let prop = PropertyListEncoder()
                let deckarchive = try! prop.encode(self.deck)
                print("saving", self.deck.cards.count)
                UserDefaults.standard.set(deckarchive, forKey: Default.deck)
                
        }
        guard
            let deckArchive = UserDefaults.standard.object(forKey: Default.deck) as? Data,
            let retrievedDeck = try? PropertyListDecoder().decode(Deck.self, from: deckArchive),
            let cardsInUseArchive = UserDefaults.standard.object(forKey: Default.cardsInUse) as? Data,
            let cardsInUse = try? PropertyListDecoder().decode([Card?].self, from: cardsInUseArchive),
            cardsInUse.count > 0
            else {
                self.doNewDeck(self)
                print("starting fresh", self.deck.cards.count)
                return
            }
        print("retrieving", retrievedDeck.cards.count)
        self.deck = retrievedDeck
        self.cardsInUse.removeAll()
        self.cardsInUse.append(contentsOf: cardsInUse)
    }

    @IBAction func doShuffle(_ sender: Any) {
        self.cardsInUse.append(self.deck.deal())
        self.cardsInUse.append(self.deck.deal())
        self.cardsInUse.append(self.deck.deal())
        for _ in 1...10 {
            self.deck.undeal(self.cardsInUse.first!!)
            self.cardsInUse.removeFirst()
            self.deck.undeal(self.cardsInUse.first!!)
            self.cardsInUse.removeFirst()
            self.deck.undeal(self.cardsInUse.first!!)
            self.cardsInUse.removeFirst()
            deck.shuffle()
            self.cardsInUse.append(self.deck.deal())
            self.cardsInUse.append(self.deck.deal())
            self.cardsInUse.append(self.deck.deal())
        }
        print(deck.cards.count)
    }
    
    @IBAction func doNewDeck(_ sender: Any) {
        self.deck = Deck()
        print(deck.cards.count)
        deck.shuffle()
        self.cardsInUse.removeAll()
        for _ in 1...16 {
            self.cardsInUse.append(self.deck.deal())
        }
        print(deck.cards.count)
    }
}

