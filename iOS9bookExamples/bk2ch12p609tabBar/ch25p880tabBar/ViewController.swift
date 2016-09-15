

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tabbar : UITabBar!
    var items : [UITabBarItem] = {
        Array(1..<8).map {
            UITabBarItem(
                tabBarSystemItem:UITabBarSystemItem(rawValue:$0)!, tag:$0)
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabbar.items = Array(self.items[0..<4]) + [UITabBarItem(tabBarSystemItem: .More, tag: 0)]
        self.tabbar.selectedItem = self.tabbar.items![0]
    }
}

extension ViewController : UITabBarDelegate {
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        print("did select item with tag \(item.tag)")
        if item.tag == 0 {
            // More button
            tabBar.selectedItem = nil
            tabBar.beginCustomizingItems(self.items)
        }
    }
    func tabBar(tabBar: UITabBar, didEndCustomizingItems items: [UITabBarItem], changed: Bool) {
        self.tabbar.selectedItem = self.tabbar.items![0]
    }
}
