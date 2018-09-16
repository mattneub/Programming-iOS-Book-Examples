//
//  ViewController.swift
//  JSONTest
//
//  Created by Matt Neuburg on 8/12/18.
//  Copyright © 2018 Matt Neuburg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    let sess : URLSession = {
        let config = URLSessionConfiguration.ephemeral
        let s = URLSession(configuration: config)
        return s
    }()
    @IBAction func doGo(_ sender: Any) {
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "quotesondesign.com"
        comp.path = "/wp-json/posts"
        var qi = [URLQueryItem]()
        qi.append(URLQueryItem(name: "filter[orderby]", value: "rand"))
        qi.append(URLQueryItem(name: "filter[posts_per_page]", value: "1"))
        comp.queryItems = qi
        if let url = comp.url {
            let d = self.sess.dataTask(with: url) { data,_,_ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.parse(data)
                    }
                }
            }
            d.resume()
        }
    }
    
    func parse(_ data:Data) {
        struct Quote : Decodable {
            let author : String
            let tag : String
            enum CodingKeys : String, CodingKey {
                case author = "title"
                case tag = "content"
            }
        }
        print(String(data: data, encoding: .utf8)!)
        if let arr = try? JSONDecoder().decode([Quote].self, from: data) {
            let quote = arr.first!
            self.authorLabel.text = quote.author
            let data = quote.tag.data(using: .utf8)!
            let html = NSAttributedString.DocumentType.html
            if let mas = try? NSMutableAttributedString(
                data: data,
                options: [.documentType : html],
                documentAttributes: nil) {
                let s = mas.string as NSString
                mas.addAttributes(
                    [.font:UIFont(name: "Georgia", size: 18)!],
                    range: NSRange(location: 0, length: s.length))
                self.quoteLabel.attributedText = mas
            }
        }
    }
}

