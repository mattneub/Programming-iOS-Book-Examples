

import UIKit

// demonstrating bug that makes `possibleTitles` useless

struct Titles {
    static let short = "Hi"
    static let long = "Greetings Earth People"
}

class ViewController: UIViewController, UIToolbarDelegate {
    
    @IBOutlet weak var item: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toolbar.delegate = self
        self.item.possibleTitles = [Titles.short, Titles.long]
        self.item.title = Titles.long
    }
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

    @IBAction func doItem(_ sender: Any) {
        if self.item.title == Titles.short {
            self.item.title = Titles.long
        } else {
            self.item.title = Titles.short
        }
    }

}

