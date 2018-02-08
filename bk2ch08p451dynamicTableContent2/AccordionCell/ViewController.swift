

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var showDatePicker = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func toggleDatePickerCell(_ sender: AnyObject) {
        self.showDatePicker = !self.showDatePicker
        self.tableView.performBatchUpdates(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        switch indexPath.row {
        case 0:
            cell.backgroundColor = .red

        case 2:
            cell.backgroundColor = .orange

        case 1:
            if cell.contentView.subviews.count == 0 {
                let dp = UIDatePicker(frame:CGRect(x: 0,y: 0,width: cell.contentView.bounds.width,height: 200))
                cell.contentView.addSubview(dp)
                cell.clipsToBounds = true
            }

        default: break
        }
        return cell
    }
    
    let datePickerPath = IndexPath(row: 1, section: 0)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == datePickerPath {
            return self.showDatePicker ? 200 : 0
        }
        return tableView.rowHeight
    }

}

