

import UIKit

// Do not run this project! It's here purely for the compilation check

func delay(_ delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        delay(0.1) {
        let t = TracksViewController(
            mediaItemCollection: self.albums[indexPath.row])
        self.navigationController?.pushViewController(t, animated: true)
        }
    }


}

