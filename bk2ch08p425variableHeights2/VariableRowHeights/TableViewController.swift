

import UIKit

class MyView : UIView {
    var h : CGFloat = 200 {
        didSet {
            self.invalidateIntrinsicContentSize() // *
        }
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(width:300, height:self.h)
    }
}

class MyCell : UITableViewCell {
    @IBOutlet var v : MyView!
    @IBOutlet var vh : NSLayoutConstraint!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        let v = MyView()
        self.contentView.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        self.v = v
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            v.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TableViewController: UITableViewController {
    
    let cellID = "Cell"
    
    override func viewDidLoad() {
        self.tableView.rowHeight = UITableView.automaticDimension
        // self.tableView.estimatedRowHeight = 150
        self.tableView.estimatedRowHeight = UITableView.automaticDimension // new in iOS 11
        self.tableView.allowsSelection = false
        self.tableView.register(MyCell.self, forCellReuseIdentifier: self.cellID)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! MyCell
        let even = indexPath.row % 2 == 0
        cell.v.backgroundColor = even ? .red : .green
        cell.v.h = even ? 40 : 80
        
        return cell
    }

}
