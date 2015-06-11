

import UIKit

// tap button, watch console when you turn on Sharing in iTunes


class ViewController: UIViewController, NSNetServiceBrowserDelegate, NSNetServiceDelegate {
    var nsb : NSNetServiceBrowser!
    var services = [NSNetService]()
    
    @IBAction func doButton (sender:AnyObject!) {
        println("listening for services...")
        self.services.removeAll()
        self.nsb = NSNetServiceBrowser()
        self.nsb.delegate = self
        self.nsb.searchForServicesOfType("_daap._tcp", inDomain: "")
    }
    
    func updateInterface () {
        for service in self.services {
            if service.port == -1 {
                println("service \(service.name) of type \(service.type)" +
                    " not yet resolved")
                service.delegate = self
                service.resolveWithTimeout(10)
            } else {
                println("service \(service.name) of type \(service.type)," +
                    "port \(service.port), addresses \(service.addresses)")
            }
        }
    }

    func netServiceDidResolveAddress(sender: NSNetService) {
        self.updateInterface()
    }
    
    func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didFindService aNetService: NSNetService, moreComing: Bool) {
        println("adding a service")
        self.services.append(aNetService)
        if !moreComing {
            self.updateInterface()
        }
    }
    
    func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didRemoveService aNetService: NSNetService, moreComing: Bool) {
        if let ix = find(self.services, aNetService) {
            self.services.removeAtIndex(ix)
            println("removing a service")
            if !moreComing {
                self.updateInterface()
            }
        }
    }
}
