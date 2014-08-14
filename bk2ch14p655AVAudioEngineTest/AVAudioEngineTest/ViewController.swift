

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var engine = AVAudioEngine()
    
    @IBAction func doButton(sender: AnyObject) {
        engine.stop()
        
        // simplest possible "play a file" scenario
        // construct a graph
        // take out a player node
        let player = AVAudioPlayerNode()
        // open a file to play on the player node
        let url = NSBundle.mainBundle().URLForResource("aboutTiagol", withExtension: "m4a")
        let f = AVAudioFile(forReading: url, error: nil)
        // hook the player's output to the engine's mixer node
        // alternatively, could use the engine's output node (mixer is hooked to output already)
        let mixer = engine.mainMixerNode
        engine.attachNode(player)
        engine.connect(player, to: mixer, format: f.processingFormat)
        // schedule the file on the player
        player.scheduleFile(f, atTime: nil, completionHandler:{println("done")})
        // start the engine
        engine.prepare()
        engine.startAndReturnError(nil)
        // play!
        player.play()
    }

    @IBAction func doButton2(sender: AnyObject) {
        engine.stop()
        
        // simplest possible "play a buffer" scenario
        let url2 = NSBundle.mainBundle().URLForResource("Hooded", withExtension: "mp3")
        let f2 = AVAudioFile(forReading: url2, error: nil)
        let buffer = AVAudioPCMBuffer(PCMFormat: f2.processingFormat, frameCapacity: UInt32(f2.length/3)) // only need 1/3 of the original recording
        f2.readIntoBuffer(buffer, error: nil)
        
        let player2 = AVAudioPlayerNode()
        engine.attachNode(player2)
        let mixer = engine.mainMixerNode
        engine.connect(player2, to: mixer, format: f2.processingFormat)

        player2.scheduleBuffer(buffer, atTime: nil, options: nil, completionHandler: nil)
        
        engine.prepare()
        engine.startAndReturnError(nil)

        player2.play()
    }

    @IBAction func doButton3(sender: AnyObject) {
        engine.stop()
        
        let player = AVAudioPlayerNode()
        let url = NSBundle.mainBundle().URLForResource("aboutTiagol", withExtension: "m4a")
        let f = AVAudioFile(forReading: url, error: nil)
        let mixer = engine.mainMixerNode
        engine.attachNode(player)
        engine.connect(player, to: mixer, format: f.processingFormat)
        player.scheduleFile(f, atTime: nil, completionHandler:{println("done")})
        engine.prepare()
        engine.startAndReturnError(nil)
        player.play()
        
        let url2 = NSBundle.mainBundle().URLForResource("Hooded", withExtension: "mp3")
        let f2 = AVAudioFile(forReading: url2, error: nil)
        let buffer = AVAudioPCMBuffer(PCMFormat: f2.processingFormat, frameCapacity: UInt32(f2.length/3))
        f2.readIntoBuffer(buffer, error: nil)
        let player2 = AVAudioPlayerNode()
        engine.attachNode(player2)
        engine.connect(player2, to: mixer, format: f2.processingFormat)
        player2.scheduleBuffer(buffer, atTime: nil, options: .Loops, completionHandler: nil)
        // mix down a little
        player2.volume = 0.5
        player2.play()
    }
    
    @IBAction func doButton4(sender: AnyObject) {
        engine.stop()
        
        let player = AVAudioPlayerNode()
        let url = NSBundle.mainBundle().URLForResource("aboutTiagol", withExtension: "m4a")
        let f = AVAudioFile(forReading: url, error: nil)
        engine.attachNode(player)

        // add some effect nodes to the chain
        let effect = AVAudioUnitTimePitch()
        effect.rate = 0.9
        effect.pitch = -300
        engine.attachNode(effect)
        engine.connect(player, to: effect, format: f.processingFormat)
        let effect2 = AVAudioUnitReverb()
        effect2.loadFactoryPreset(.Cathedral)
        effect2.wetDryMix = 40
        engine.attachNode(effect2)
        engine.connect(effect, to: effect2, format: f.processingFormat)
        
        let mixer = engine.mainMixerNode
        engine.connect(effect2, to: mixer, format: f.processingFormat)
        player.scheduleFile(f, atTime: nil, completionHandler:{println("done")})
        engine.prepare()
        engine.startAndReturnError(nil)
        player.play()
        
        let url2 = NSBundle.mainBundle().URLForResource("Hooded", withExtension: "mp3")
        let f2 = AVAudioFile(forReading: url2, error: nil)
        let buffer = AVAudioPCMBuffer(PCMFormat: f2.processingFormat, frameCapacity: UInt32(f2.length/3))
        f2.readIntoBuffer(buffer, error: nil)
        let player2 = AVAudioPlayerNode()
        engine.attachNode(player2)
        engine.connect(player2, to: mixer, format: f2.processingFormat)
        player2.scheduleBuffer(buffer, atTime: nil, options: .Loops, completionHandler: nil)
        // mix down a little
        player.pan = -0.5
        player2.volume = 0.5
        player2.pan = 0.5
        player2.play()
        
        println(player.volume)
    }
    
    @IBAction func doStop(sender: AnyObject) {
        engine.stop()
        engine.reset()
    }
}

