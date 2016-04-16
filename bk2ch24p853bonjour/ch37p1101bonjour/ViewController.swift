

import UIKit

// tap button, watch console when you turn on Sharing in iTunes


class ViewController: UIViewController, NSNetServiceBrowserDelegate, NSNetServiceDelegate {
    var nsb : NSNetServiceBrowser!
    var services = [NSNetService]()
    
    @IBAction func doButton (_ sender:AnyObject!) {
        print("listening for services...")
        self.services.removeAll()
        self.nsb = NSNetServiceBrowser()
        self.nsb.delegate = self
        self.nsb.searchForServices(ofType:"_daap._tcp", inDomain: "")
    }
    
    func updateInterface () {
        for service in self.services {
            if service.port == -1 {
                print("service \(service.name) of type \(service.type)" +
                    " not yet resolved")
                service.delegate = self
                service.resolve(withTimeout:10)
            } else {
                print("service \(service.name) of type \(service.type)," +
                    "port \(service.port), addresses \(service.addresses)")
            }
        }
    }

    func netServiceDidResolveAddress(_ sender: NSNetService) {
        self.updateInterface()
    }
    
    func netServiceBrowser(_ aNetServiceBrowser: NSNetServiceBrowser, didFind aNetService: NSNetService, moreComing: Bool) {
        print("adding a service")
        self.services.append(aNetService)
        if !moreComing {
            self.updateInterface()
        }
    }
    
    func netServiceBrowser(_ aNetServiceBrowser: NSNetServiceBrowser, didRemove aNetService: NSNetService, moreComing: Bool) {
        if let ix = self.services.index(of:aNetService) {
            self.services.remove(at:ix)
            print("removing a service")
            if !moreComing {
                self.updateInterface()
            }
        }
    }
}
