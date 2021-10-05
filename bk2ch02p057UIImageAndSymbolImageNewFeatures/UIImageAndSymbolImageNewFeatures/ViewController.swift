

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageViews : [UIImageView]!

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            self.imageViews[0].image = await UIImage(
                named:"kittensBasket")?.byPreparingForDisplay()
            // note this is not a very good thumbnail because of the resolution mismatch
            let size = self.imageViews[1].bounds.size
            self.imageViews[1].image = await UIImage(
                named:"kittensBasket")?.byPreparingThumbnail(ofSize: size)

            // okay, so a symbol image can now have multiple "layers"

            // let's pick a multicolor image
            let name = "square.grid.3x1.folder.fill.badge.plus"
            // let name = "pencil"
            let im = UIImage(systemName: name)!//.withRenderingMode(.alwaysOriginal)//.withTintColor(.red)
//            self.imageViews[2].image = im
//            self.imageViews[3].image = im
//            self.imageViews[4].image = im
//            self.imageViews[5].image = im
//            return;

            self.imageViews[2].tintColor = .yellow
            self.imageViews[2].image = im // "monochrome", adopts the tint color throughout, no layer distinction

            do {
                let config = UIImage.SymbolConfiguration(hierarchicalColor: .green)
                self.imageViews[3].tintColor = .yellow
                self.imageViews[3].preferredSymbolConfiguration = config
                self.imageViews[3].image = im // ignores the tint color, uses opacity degrees of the hierarchical color
            }

            do {
                let config = UIImage.SymbolConfiguration.preferringMulticolor()
                self.imageViews[4].tintColor = .yellow
                self.imageViews[4].preferredSymbolConfiguration = config
                self.imageViews[4].image = im // one color is the tint color, the second color is fixed
            }

            do {
                let config = UIImage.SymbolConfiguration(paletteColors: [.red, .green, .yellow])
                self.imageViews[5].tintColor = .yellow
                self.imageViews[5].preferredSymbolConfiguration = config
                self.imageViews[5].image = im // ignores the tint color, uses the palette colors in order (no third)
            }


        }

    }


}

