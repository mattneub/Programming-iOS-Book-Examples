

import UIKit

// Do not run this project! It's here purely for the compilation check

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

extension Task where Success == Never, Failure == Never {
    static func sleep(_ seconds:Double) async {
        await self.sleep(UInt64(seconds * 1_000_000_000))
    }
    static func sleepThrowing(_ seconds:Double) async throws {
        try await self.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
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
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UITableViewController {
    let albums = [String]()
    var which = 0
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch which {
        case 0:
            delay(0.1) {
            let t = TracksViewController(
                mediaItemCollection: self.albums[indexPath.row])
            self.navigationController?.pushViewController(t, animated: true)
            }
        case 1:
            Task {
                await Task.sleep(0.1)
                let t = TracksViewController(
                    mediaItemCollection: self.albums[indexPath.row])
                self.navigationController?.pushViewController(t, animated: true)
            }
        default: break
        }
    }


}

