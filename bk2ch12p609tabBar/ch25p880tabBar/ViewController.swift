

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tabbar : UITabBar!
    var items = [UITabBarItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        for ix in 1 ..< 8 {
            self.items.append(
                UITabBarItem(
                    tabBarSystemItem: UITabBarSystemItem.fromRaw(ix)!, tag: ix
                )
            )
        }
        var arr = Array(self.items[0..<4])
        arr.append(
            UITabBarItem(tabBarSystemItem: .More, tag: 0)
        )
        self.tabbar.items = arr
        self.tabbar.selectedItem = self.tabbar.items[0] as UITabBarItem
    }
}

extension ViewController : UITabBarDelegate {
    func tabBar(tabBar: UITabBar!, didSelectItem item: UITabBarItem!) {
        println("did select item with tag \(item.tag)")
        if item.tag == 0 {
            // More button
            tabBar.selectedItem = nil
            tabBar.beginCustomizingItems(self.items)
        }
    }
    
    func tabBar(tabBar: UITabBar!, didEndCustomizingItems items: [AnyObject]!, changed: Bool) {
        self.tabbar.selectedItem = self.tabbar.items[0] as UITabBarItem
    }
}
