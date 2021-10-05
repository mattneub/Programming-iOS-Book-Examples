
import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}
extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}



class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await self.prepareImages()
        }
    }

    func prepareImages() async {
        let lightMode = UITraitCollection(userInterfaceStyle: .light)
        let darkMode = UITraitCollection(userInterfaceStyle: .dark)
        let jack = UIImage(named: "jack", in: nil, compatibleWith: lightMode)
        let jackDark = UIImage(named: "jack", in: nil, compatibleWith: darkMode)
        let size = CGSize(40,40)
        let jackPrepared = await jack?.byPreparingThumbnail(ofSize: size)
        let jackPreparedDark = await jackDark?.byPreparingThumbnail(ofSize: size)
        if let jack = jackPrepared, let jackDark = jackPreparedDark {
            let jacks = UIImageAsset()
            jacks.register(jack, with: lightMode)
            jacks.register(jackDark, with: darkMode)
            await MainActor.run {
                self.imageView.image = jack
            }
        }

        // let jack2 = await UIImage(named:"jack2.png")?.byPreparingThumbnail(ofSize: size)
        let jack2 = UIImage(named:"jack2.png")
        await MainActor.run {
            self.button1.setImage(jack2, for:.normal)
            self.button2.setImage(jack2?.withRenderingMode(.alwaysOriginal), for:.normal)
        }

    }


}

