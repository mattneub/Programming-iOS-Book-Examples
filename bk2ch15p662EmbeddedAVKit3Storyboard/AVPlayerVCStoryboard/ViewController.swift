//
//  ViewController.swift
//  AVPlayerVCStoryboard
//
//  Created by Matt Neuburg on 10/16/17.
//  Copyright © 2017 Matt Neuburg. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let avc = segue.destination as? AVPlayerViewController {
            let url = Bundle.main.url(forResource: "ElMirage", withExtension: "mp4")!
            let player = AVPlayer(url: url)
            avc.player = player
        }
    }

}

