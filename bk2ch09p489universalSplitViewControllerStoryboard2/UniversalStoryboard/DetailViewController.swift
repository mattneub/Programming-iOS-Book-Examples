

import UIKit

// pure template code, more or less
// I've added some comments and logging


class DetailViewController: UIViewController {
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var detailItem: AnyObject? {
        didSet {
            print("didset")
            self.configureView()
        }
    }

    func configureView() {
        // problem is that when user taps a date in the master view...
        // an entirely new detail view controller is created
        // thus its viewDidLoad is called, and configureView is called...
        // at a time when there is no detailItem yet
        // Then detailItem is set, and configureView is called again!
        // This seems nutty but we have to cover every case...
        // ... because we don't know the order of events:
        // could be detailItem first, then viewDidLoad
        // in portrait view, it is; on iPhone it is
        print("configureView")
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                print(self.detailItem)
                print(self.detailDescriptionLabel)
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        self.configureView()
    }
}

