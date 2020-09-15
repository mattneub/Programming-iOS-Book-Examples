

import UIKit

/*
 Amazing facts from the documentation:
 
 "The iCloud file provider creates a folder for your app in the user’s iCloud Drive. Users can access documents from this folder, or from anywhere in their iCloud Drive. The system automatically handles access to iCloud for you; you don't need to enable your app’s iCloud capabilities."
 
 So without doing _anything_, we are iCloud-savvy!
 
 I'm not actually sure I like this. If the user turns off iCloud Drive, our app is bricked.
 
 */


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.allowsDocumentCreation = true
        self.allowsPickingMultipleItems = false
        
        self.title = "People Groups" // failed experiment
        
        // Update the style of the UIDocumentBrowserViewController
        // self.browserUserInterfaceStyle = .dark
        // self.view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        print("doc creation")
        // Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
        // Make sure the importHandler is always called, even if the user cancels the creation request.
        
        var docname = "People"
        
        let alert = UIAlertController(title: "Name for new people group:", message: nil, preferredStyle: .alert)
        alert.addTextField { tf in
            tf.autocapitalizationType = .words
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) {_ in
            importHandler(nil, .none)
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
            if let proposal = alert.textFields?[0].text {
                if !proposal.trimmingCharacters(in: .whitespaces).isEmpty {
                    docname = proposal
                }
            }
            
            var which : Int { return 2 }
            switch which {
            case 1: // this is basically how their template is configured and how the video example works
                // blank document exists in our app bundle
                let newDocumentURL = Bundle.main.url(forResource: "newdoc", withExtension: "pplgrp2new")
                if newDocumentURL != nil {
                    importHandler(newDocumentURL, .copy)
                } else {
                    importHandler(nil, .none)
                }
            case 2: // more interesting; we create the document into the temp directory
                // similar code appears in the docs on this method
                let fm = FileManager.default
                let temp = fm.temporaryDirectory
                let fileURL = temp.appendingPathComponent(docname + ".pplgrp2new")
                let newdoc = PeopleDocument(fileURL: fileURL)
                newdoc.save(to: fileURL, for: .forOverwriting) { ok in
                    guard ok else { importHandler(nil, .none); return }
                    newdoc.close() { ok in
                        guard ok else { importHandler(nil, .none); return }
                        importHandler(fileURL, .move)
                    }
                }
            default: fatalError("we should never get here")
            }
        })
        self.present(alert, animated: true)
        
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        print("doc did pick")
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        self.presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        print("doc did import")
        // Present the Document View Controller for the new newly created document
        self.presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        // replace template code...
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let documentViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
//        documentViewController.document = PeopleDocument(fileURL: documentURL)
//        present(documentViewController, animated: true, completion: nil)
        // ... with this:
        let lister = PeopleLister(fileURL: documentURL)
        let nav = UINavigationController(rootViewController: lister)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
}

