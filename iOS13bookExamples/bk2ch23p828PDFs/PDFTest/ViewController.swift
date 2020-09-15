

import UIKit
import PDFKit

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



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let v = PDFView(frame:self.view.bounds) // prevent initial zoom issues
        self.view.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        let safe = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: safe.topAnchor),
            v.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
        ])
        var which : Int { return 2 }
        switch which {
        case 1: // load an existing document
            let url = Bundle.main.url(forResource: "notes", withExtension: "pdf")!
            let doc = PDFDocument(url: url)
            v.document = doc
        case 2: // make our own document with our own drawn page
            let doc = PDFDocument()
            v.document = doc
            doc.insert(MyPage(), at: 0)
        default: break
        }
        v.usePageViewController(true)
        v.backgroundColor = .white
    }
}

class MyPage : PDFPage {
    override func draw(with box: PDFDisplayBox, to context: CGContext) {
        UIGraphicsPushContext(context)
        context.saveGState()
        print(self.document?.index(for: self) as Any) // how to determine where we are
        let r = self.bounds(for: box)
        let s = NSAttributedString(string: "Hello, world!", attributes: [
            .font : UIFont(name: "Georgia", size: 80)!
            ])
        let sz = s.boundingRect(with: CGSize(10000,10000), options: .usesLineFragmentOrigin, context: nil)
        // but there's just one little problem; PDF contexts are flipped relative to iOS!
        context.translateBy(x: 0, y: r.height)
        context.scaleBy(x: 1, y: -1)
        // now we can draw
        s.draw(at: CGPoint(
            (r.maxX - r.minX) / 2 - sz.width / 2,
            (r.maxY - r.minY) / 2 - sz.height / 2
        ))
        context.restoreGState()
        UIGraphicsPopContext()
    }
}


