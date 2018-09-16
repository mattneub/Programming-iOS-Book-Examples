

import UIKit

class ViewController: UIViewController {
    @IBAction func doCreate(_ sender: Any) {
        let fm = FileManager.default
        let docurl = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let d = FileWrapper(directoryWithFileWrappers: [:])
        let imnames = ["manny.jpg", "moe.jpg", "jack.jpg"]
        for imname in imnames {
            let im = UIImage(named:imname)!
            let imfw = FileWrapper(regularFileWithContents: im.jpegData(compressionQuality: 1)!)
            imfw.preferredFilename = imname
            d.addFileWrapper(imfw)
        }
        let list = try! JSONEncoder().encode(imnames)
        let listfw = FileWrapper(regularFileWithContents: list)
        listfw.preferredFilename = "list"
        d.addFileWrapper(listfw)
        let fwurl = docurl.appendingPathComponent("myFileWrapper")
        try? fm.removeItem(at: fwurl)
        do {
            try d.write(to: fwurl, originalContentsURL: nil)
            print("ok")
        } catch {
            print(error)
        }
    }
    
    @IBAction func doRead(_ sender: Any) {
        let fm = FileManager.default
        let docurl = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fwurl = docurl.appendingPathComponent("myFileWrapper")
        do {
            let d = try FileWrapper(url: fwurl)
            if let list = d.fileWrappers?["list"]?.regularFileContents {
                let imnames = try! JSONDecoder().decode([String].self, from: list)
                print("got", imnames)
                for imname in imnames {
                    if let imdata = d.fileWrappers?[imname]?.regularFileContents {
                        print("got image data for", imname)
                        // in real life, do something with the image here
                        _ = imdata
                    }
                }
            } else {
                print("no list")
            }
        } catch {
            print(error); return
        }
        
    }
    
}

