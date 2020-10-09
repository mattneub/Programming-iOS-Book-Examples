

import UIKit

final class ViewController3: UITableViewController {
    struct PepBoy : Hashable {
        let name: String
    }
    private var datasource : UITableViewDiffableDataSource<String,PepBoy>!
    private var backingStore = [PepBoy:Bool]() // *
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellid = "cell"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
        self.datasource = UITableViewDiffableDataSource<String,PepBoy>(tableView:tableView) { [unowned self] tv, ip, pep in
            let cell = tv.dequeueReusableCell(withIdentifier: cellid, for: ip)
            var config = cell.defaultContentConfiguration()
            config.text = pep.name
            config.image = UIImage(named: pep.name.lowercased())
            config.imageProperties.maximumSize = CGSize(width: 30, height: 30)
            cell.contentConfiguration = config
            // ----
            var star = cell.accessoryView as? UIImageView
            if star == nil {
                star = UIImageView()
                star?.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.starTapped))
                star?.addGestureRecognizer(tap)
                cell.accessoryView = star
            }
            let isFavorite = self.backingStore[pep] ?? false // *
            star?.image = UIImage(systemName: isFavorite ? "star.fill" : "star")
            star?.sizeToFit()
            return cell
        }
        var snap = NSDiffableDataSourceSnapshot<String,PepBoy>()
        snap.appendSections(["Dummy"])
        snap.appendItems(["Manny","Moe","Jack"].map {
            let pep = PepBoy(name:$0)
            self.backingStore[pep] = false
            return pep
        })
        self.datasource.apply(snap, animatingDifferences: false)
    }
    @objc private func starTapped(_ gr : UIGestureRecognizer) {
        guard let cell = gr.view?.next(ofType: UITableViewCell.self) else { return }
        guard let ip = self.tableView.indexPath(for: cell) else { return }
        guard let pep = self.datasource.itemIdentifier(for: ip) else { return }
        self.backingStore[pep] = !self.backingStore[pep, default:true] // *
        var snap = self.datasource.snapshot()
        print(pep)
        snap.reloadItems([pep])
        print(snap.itemIdentifiers(inSection: "Dummy"))
        self.datasource.apply(snap, animatingDifferences: false)
    }
}
