//
//  ViewController.swift
//  JSONTest
//
//  Created by Matt Neuburg on 8/12/18.
//  Copyright © 2018 Matt Neuburg. All rights reserved.
//

import UIKit

enum IntOrString: Decodable {
    case int(Int)
    case string(String)
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            throw DecodingError.typeMismatch(
                IntOrString.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Neither String nor Int"))
        }
    }
}


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
        // https://quotesondesign.com/wp-json/wp/v2/posts/?orderby=rand
        // but it doesn't seem to randomize very well, so I've dropped that
        comp.scheme = "https"
        comp.host = "quotesondesign.com"
        comp.path = "/wp-json/wp/v2/posts"
        var qi = [URLQueryItem]()
        qi.append(URLQueryItem(name: "orderby", value: "rand"))
        qi.append(URLQueryItem(name: "per_page", value: "1"))
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
        struct Item : Decodable {
            let value : String
            enum CodingKeys : String, CodingKey {
                case value = "rendered"
            }
        }
        struct Quote : Decodable {
            let author : Item
            let tag : Item
            enum CodingKeys : String, CodingKey {
                case author = "title"
                case tag = "content"
            }
        }
        struct Quote2 : Decodable {
            let author : String
            let quotation : String
            enum CodingKeys : String, CodingKey {
                case author = "title"
                case quotation = "content"
            }
            private struct Item2 : Decodable {
                let value : String
                enum CodingKeys : String, CodingKey {
                    case value = "rendered"
                }
            }
            init(from decoder: Decoder) throws {
                let con = try decoder.container(keyedBy: CodingKeys.self)
                let author = try con.decode(Item2.self, forKey: .author)
                self.author = author.value
                let quotation = try con.decode(Item2.self, forKey: .quotation)
                self.quotation = quotation.value
            }
        }
        struct Quote3 : Decodable {
            struct AnyCodingKey : CodingKey {
              var stringValue: String
              var intValue: Int?

              init(_ codingKey: CodingKey) {
                self.stringValue = codingKey.stringValue
                self.intValue = codingKey.intValue
              }

              init(stringValue: String) {
                self.stringValue = stringValue
                self.intValue = nil
              }

              init(intValue: Int) {
                self.stringValue = String(intValue)
                self.intValue = intValue
              }
            }
            init(from decoder: Decoder) throws {
                let con = try decoder.container(keyedBy: AnyCodingKey.self)
                let keys = con.allKeys
                print(keys)
            }
        }


        print(String(data: data, encoding: .utf8)!)
//        _ = try? JSONDecoder().decode([Quote3].self, from: data)
//        return;
        if let arr = try? JSONDecoder().decode([Quote2].self, from: data) {
            let quote = arr.first!
//            self.authorLabel.text = quote.author.value
//            let quotation = quote.tag.value
            self.authorLabel.text = quote.author
            let quotation = quote.quotation
            let html = NSAttributedString.DocumentType.html
            let enc = String.Encoding.utf8.rawValue
            if let mas = try? NSMutableAttributedString(
                data: quotation.data(using: .utf8)!,
                options: [.documentType : html, .characterEncoding : enc],
                documentAttributes: nil) {
                let s = mas.string as NSString
                print(s)
                mas.addAttributes(
                    [.font:UIFont(name: "Georgia", size: 18)!],
                    range: NSRange(location: 0, length: s.length))
                self.quoteLabel.attributedText = mas
            }
        }
    }
}

