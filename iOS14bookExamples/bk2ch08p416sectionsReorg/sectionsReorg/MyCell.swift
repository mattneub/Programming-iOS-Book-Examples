

import UIKit

class MyCell: UITableViewCell {
    struct Configuration {
        let stateName : String
    }
    func configure(_ configuration: Configuration) {
        self.textLabel!.text = configuration.stateName
        
        // this part is not in the book, it's just for fun
        var stateName = configuration.stateName
        stateName = stateName.lowercased()
        stateName = stateName.replacingOccurrences(of: " ", with:"")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        self.imageView!.image = im

    }

}
