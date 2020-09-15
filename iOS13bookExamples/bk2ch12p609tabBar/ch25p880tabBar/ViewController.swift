

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tabbar : UITabBar!
    var items : [UITabBarItem] = {
        Array(1..<8).map {
            UITabBarItem(
                tabBarSystemItem:UITabBarItem.SystemItem(rawValue:$0)!, tag:$0)
        }
    }()

    override func viewDidLoad() {
        let tabbar = UITabBar()
        self.view.addSubview(tabbar)
        self.tabbar = tabbar
        self.tabbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tabbar.bottomAnchor.constraint(equalTo:
                self.view.safeAreaLayoutGuide.bottomAnchor),
            self.tabbar.leadingAnchor.constraint(equalTo:
                self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tabbar.trailingAnchor.constraint(equalTo:
                self.view.safeAreaLayoutGuide.trailingAnchor),
            ])
        
        
        super.viewDidLoad()
        self.tabbar.items = Array(self.items[0..<4]) + [UITabBarItem(tabBarSystemItem: .more, tag: 0)]
        self.tabbar.selectedItem = self.tabbar.items![0]
        self.tabbar.delegate = self
        
    }
}

extension ViewController : UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("did select item with tag \(item.tag)")
        if item.tag == 0 {
            // More button
            tabBar.selectedItem = nil
            tabBar.beginCustomizingItems(self.items)
        }
    }
    func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
        self.tabbar.selectedItem = self.tabbar.items![0]
    }
}
