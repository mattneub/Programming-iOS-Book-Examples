

import UIKit

actor BankAccount {
    nonisolated let accountNumber: Int
    init(accountNumber:Int) {
        self.accountNumber = accountNumber
    }
}

// according to the proposal, this should allow BankAccount to adopt Hashable
// but it doesn't; I've reported this as a bug
// still there in RC
extension BankAccount: Hashable {
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(accountNumber)
    }
    static func ==(lhs:BankAccount, rhs:BankAccount) -> Bool {
        lhs.accountNumber == rhs.accountNumber
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

