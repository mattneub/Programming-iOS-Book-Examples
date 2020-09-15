

import UIKit

// the very weird behavior of `withTintColor`
// only the starred cases (2b, 3, and 7) yield the color you specify (yellow)!
// this seems to be because we also say `.alwaysOriginal`
// except 2b where we started with an .original type image in an original type context

class ViewController: UIViewController {
    @IBOutlet var b: [UIButton]!
    @IBOutlet var iv: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let smiley = UIImage(named:"Smiley")!
        let smileyTemplate = UIImage(named:"SmileyTemplate")!
        let doc = UIImage(systemName:"doc")!
        
        if let w = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
            w.tintColor = .red
        }
        
        self.b[0].setImage(smiley, for:.normal) // red template as expected
        self.iv[0].image = smiley // normal as expected
        
        // self.b.tintColor = .yellow // yellow template as expected
        
        self.b[1].setImage(smiley.withTintColor(.yellow), for:.normal) // no, it's red because we're in a template context
        self.iv[1].image = smileyTemplate.withTintColor(.yellow) // no, it's template but red
        
        self.b[2].setImage(smiley.withTintColor(.yellow), for:.normal) // no, it's red because we're in a template context
        self.iv[2].image = smiley.withTintColor(.yellow) // yes, it's template and yellow because we started original // *
        
        self.b[3].setImage(smiley.withTintColor(.yellow, renderingMode: .alwaysOriginal), for:.normal) // now yellow template // *
        self.iv[3].image = smileyTemplate.withTintColor(.yellow, renderingMode: .alwaysOriginal) // now yellow template // *
        
        // my last remaining question is: are symbol images different?
        
        self.b[4].setImage(doc, for:.normal) // red as expected
        self.iv[4].image = doc // red as expected, it's a template of course
        
        self.b[5].setImage(doc.withTintColor(.yellow), for:.normal) // no, it's red because we're in a template context?
        self.iv[5].image = doc.withTintColor(.yellow) // no, it's red! even though we're in a normal context
        
        self.b[6].setImage(doc.withTintColor(.yellow, renderingMode: .alwaysOriginal), for:.normal) // now yellow template // *
        self.iv[6].image = doc.withTintColor(.yellow, renderingMode: .alwaysOriginal) // now yellow template // *
        
//        let im = UIImage(systemName:"circle.fill")?.withTintColor(.yellow) // nope, red
//        let iv = UIImageView(image:im)
//        self.view.addSubview(iv)


    }


}

