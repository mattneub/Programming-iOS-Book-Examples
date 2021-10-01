

import UIKit

class ViewController: UICollectionViewController {
    let cellID = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cellID)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    let pep = ["manny","moe","jack"]
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath)
        var config = UIListContentConfiguration.cell()
        config.image = UIImage(named: self.pep[indexPath.item])
        cell.contentConfiguration = config
        return cell
    }
}


class ViewController2: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    let cellreg = UICollectionView.CellRegistration<UICollectionViewCell, String>() { cell, indexPath, name in
        var config = UIListContentConfiguration.cell()
        config.image = UIImage(named: name)
        cell.contentConfiguration = config
    }
    let pep = ["manny","moe","jack"]
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueConfiguredReusableCell(using: cellreg, for: indexPath, item: self.pep[indexPath.item])
    }
}

class ViewController3: UICollectionViewController {
    var datasource : UICollectionViewDiffableDataSource<String,String>!
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellreg = UICollectionView.CellRegistration<UICollectionViewCell, String>() { cell, indexPath, name in
            var config = UIListContentConfiguration.cell()
            config.image = UIImage(named: name)
            cell.contentConfiguration = config
        }
        self.datasource = UICollectionViewDiffableDataSource<String,String>(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellreg, for: indexPath, item: item)
        }
        var snap = NSDiffableDataSourceSnapshot<String,String>()
        snap.appendSections(["pepboys"])
        let pep = ["manny","moe","jack"]
        snap.appendItems(pep)
        self.datasource.apply(snap, animatingDifferences: false)
    }
}

class MyCollectionViewDataSource : UICollectionViewDiffableDataSource<String,String> {
    init(_ collectionView: UICollectionView) {
        let cellreg = UICollectionView.CellRegistration<UICollectionViewCell, String>() { cell, indexPath, name in
            var config = UIListContentConfiguration.cell()
            config.image = UIImage(named: name)
            cell.contentConfiguration = config
        }
        super.init(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellreg, for: indexPath, item: item)
        }
        var snap = NSDiffableDataSourceSnapshot<String,String>()
        snap.appendSections(["pepboys"])
        let pep = ["manny","moe","jack"]
        snap.appendItems(pep)
        self.apply(snap, animatingDifferences: false)
    }
}

class ViewController4: UICollectionViewController {
    lazy var datasource = MyCollectionViewDataSource(self.collectionView)
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = self.datasource // tickle the lazy var
    }
}

