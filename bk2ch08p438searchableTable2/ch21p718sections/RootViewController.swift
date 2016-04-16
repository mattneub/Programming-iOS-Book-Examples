

import UIKit

class MySearchController : UISearchController {
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

class RootViewController : UITableViewController, UISearchBarDelegate {
    var sectionNames = [String]()
    var sectionData = [[String]]()
    var searcher : UISearchController!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        let s = try! String(contentsOfFile: NSBundle.main().pathForResource("states", ofType: "txt")!, encoding: NSUTF8StringEncoding)
        let states = s.components(separatedBy:"\n")
        var previous = ""
        for aState in states {
            // get the first letter
            let c = String(aState.characters.prefix(1))
            // only add a letter to sectionNames when it's a different letter
            if c != previous {
                previous = c
                self.sectionNames.append( c.uppercased() )
                // and in that case also add new subarray to our array of subarrays
                self.sectionData.append( [String]() )
            }
            sectionData[sectionData.count-1].append( aState )
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        
        self.tableView.sectionIndexColor = UIColor.white()
        self.tableView.sectionIndexBackgroundColor = UIColor.red()
        // self.tableView.sectionIndexTrackingBackgroundColor = UIColor.blue()
        // self.tableView.backgroundColor = UIColor.yellow()
        self.tableView.backgroundView = {
            let v = UIView()
            v.backgroundColor = UIColor.yellow()
            return v
            }()
        
        let src = SearchResultsController() // we will configure later
        let searcher = MySearchController(searchResultsController: src)
        self.searcher = searcher
        searcher.delegate = self // so we can configure results controller and presentation
        // put the search controller's search bar into the interface
        let b = searcher.searchBar
        b.autocapitalizationType = .none
        b.sizeToFit()
        b.scopeButtonTitles = ["Starts", "Contains"] // won't show in the table
        self.tableView.tableHeaderView = b
        self.tableView.reloadData()
        self.tableView.scrollToRow(at:
            NSIndexPath(forRow: 0, inSection: 0),
            at:.top, animated:false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionNames.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionData[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) 
        let s = self.sectionData[indexPath.section][indexPath.row]
        cell.textLabel!.text = s
        
        // this part is not in the book, it's just for fun
        var stateName = s
        stateName = stateName.lowercased()
        stateName = stateName.replacingOccurrences(of:" ", with:"")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        cell.imageView!.image = im
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView
            .dequeueReusableHeaderFooterView(withIdentifier:"Header")!
        if h.tintColor != UIColor.red() {
            h.tintColor = UIColor.red() // invisible marker, tee-hee
            h.backgroundView = UIView()
            h.backgroundView?.backgroundColor = UIColor.black()
            let lab = UILabel()
            lab.tag = 1
            lab.font = UIFont(name:"Georgia-Bold", size:22)
            lab.textColor = UIColor.green()
            lab.backgroundColor = UIColor.clear()
            h.contentView.addSubview(lab)
            let v = UIImageView()
            v.tag = 2
            v.backgroundColor = UIColor.black()
            v.image = UIImage(named:"us_flag_small.gif")
            h.contentView.addSubview(v)
            lab.translatesAutoresizingMaskIntoConstraints = false
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat:
                    "H:|-5-[lab(25)]-10-[v(40)]",
                    options:[], metrics:nil, views:["v":v, "lab":lab]),
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:|[v]|",
                    options:[], metrics:nil, views:["v":v]),
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:|[lab]|",
                    options:[], metrics:nil, views:["lab":lab])
                ].flatten().map{$0})
        }
        let lab = h.contentView.withTag(1) as! UILabel
        lab.text = self.sectionNames[section]
        return h
        
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionNames
    }
}

extension RootViewController : UISearchControllerDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    var which : Int {return 1}
    func present(_ sc: UISearchController) {
        print("search!")
        // good opportunity to control timing of search results controller configuration
        let src = sc.searchResultsController as! SearchResultsController
        src.take(data:self.sectionData) // that way if it changes we are up to date
        sc.searchResultsUpdater = src
        sc.searchBar.delegate = src
        
        switch which {
        case 0: break
        case 1:
            sc.transitioningDelegate = self
            sc.modalPresentationStyle = .custom // ?
        default: break
        }
        self.present(sc, animated: true, completion: nil)
    }
    
    func presentationController(forPresentedViewController presented: UIViewController, presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let p = UIPresentationController(presentedViewController: presented, presenting: presenting)
        print("wow") // never called, sorry
        return p
    }
    
    func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissedController dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let vc1 = transitionContext.viewController(forKey:UITransitionContextFromViewControllerKey)!
        let vc2 = transitionContext.viewController(forKey:UITransitionContextToViewControllerKey)!
        
        let con = transitionContext.containerView()!
        
        // let r1start = transitionContext.initialFrame(for:vc1)
        let r2end = transitionContext.finalFrame(for:vc2)
        
        // let v1 = transitionContext.view(forKey:UITransitionContextFromViewKey)
        let v2 = transitionContext.view(forKey:UITransitionContextToViewKey)

        if let v2 = v2 { // presenting, vc2 is the search controller
            
            // our responsibilities are:
            // get vc2 into the interface, obviously
            // get **the search bar** into the presented interface!
            // and we can animate that
            // (plus we are responsible for the Cancel button)
            
            con.addSubview(v2)
            v2.frame = r2end
            let sc = vc2 as! UISearchController
            let sb = sc.searchBar
            sb.removeFromSuperview()
            // hold my beer and watch _this_!
            sb.showsScopeBar = true
            sb.sizeToFit()
            v2.addSubview(sb)
            sb.frame.origin.y = -sb.frame.height
            UIView.animate(withDuration:0.3, animations: {
                sb.frame.origin.y = 0
                }, completion: {
                    _ in
                    sb.setShowsCancelButton(true, animated: true)
                    transitionContext.completeTransition(true)
                })
        } else { // dismissing, vc1 is the search controller
            
            // we have no major responsibilities...
            // but if we showed the cancel button and we don't want it in the normal interface,
            // we need to get rid of it now; similarly with the scope bar
            
            let sc = vc1 as! UISearchController
            let sb = sc.searchBar
            sb.showsCancelButton = false
            sb.showsScopeBar = false
            sb.sizeToFit()

            UIView.animate(withDuration:0.3, animations: {
                }, completion: {
                    _ in
                    transitionContext.completeTransition(true)
                })
        }
        
    }

}
