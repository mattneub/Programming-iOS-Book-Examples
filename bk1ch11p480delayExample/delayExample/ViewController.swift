

import UIKit

// Do not run this project! It's here purely for the compilation check

func delay(_ delay:Double, closure:()->()) {
    let when = DispatchTime.now()
        + Double(Int64(delay * Double(NSEC_PER_SEC)))
        / Double(NSEC_PER_SEC)
    DispatchQueue.main.after(when: when, execute: closure)
}

class MyCell : UITableViewCell {
    let activityIndicator = UIActivityIndicatorView()
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        super.setSelected(selected, animated: animated)
    }
}

class TracksViewController : UIViewController {
    init(mediaItemCollection:String) {
        super.init(nibName:nil, bundle:nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UITableViewController {
    let albums = [String]()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delay(0.1) {
        let t = TracksViewController(
            mediaItemCollection: self.albums[indexPath.row])
        self.navigationController?.pushViewController(t, animated: true)
        }
    }


}

