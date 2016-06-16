

import UIKit
import AVFoundation

// warning: turn off your "All Exceptions" breakpoint

class ViewController: UIViewController {
    
    var engine = AVAudioEngine()
    
    @IBAction func doButton(_ sender: AnyObject) {
        engine.stop()
        
        // simplest possible "play a file" scenario
        // construct a graph
        // take out a player node
        let player = AVAudioPlayerNode()
        // open a file to play on the player node
        let url = Bundle.main().urlForResource("aboutTiagol", withExtension: "m4a")!
        let f = try! AVAudioFile(forReading: url)
        // hook the player's output to the engine's mixer node
        // alternatively, could use the engine's output node (mixer is hooked to output already)
        let mixer = engine.mainMixerNode
        engine.attach(player)
        engine.connect(player, to: mixer, format: f.processingFormat)
        // schedule the file on the player
        player.scheduleFile(f, at: nil) {print("done")}
        // start the engine
        engine.prepare()
        do {
            try engine.start()
            player.play()
        } catch {}
    }

    
    @IBAction func doButton2(_ sender: AnyObject) {
        engine.stop()
        
        // simplest possible "play a buffer" scenario
        let url2 = Bundle.main().urlForResource("Hooded", withExtension: "mp3")!
        let f2 = try! AVAudioFile(forReading: url2)
        let buffer = AVAudioPCMBuffer(pcmFormat: f2.processingFormat, frameCapacity: UInt32(f2.length/3)) // only need 1/3 of the original recording
        try! f2.read(into:buffer)
        
        let player2 = AVAudioPlayerNode()
        engine.attach(player2)
        let mixer = engine.mainMixerNode
        engine.connect(player2, to: mixer, format: f2.processingFormat)

        player2.scheduleBuffer(buffer)
        
        engine.prepare()
        
        do {
            try engine.start()
            player2.play()
        } catch {}
    }
    


    @IBAction func doButton3(_ sender: AnyObject) {
        engine.stop()
        
        let player = AVAudioPlayerNode()
        let url = Bundle.main().urlForResource("aboutTiagol", withExtension: "m4a")!
        let f = try! AVAudioFile(forReading: url)
        let mixer = engine.mainMixerNode
        engine.attach(player)
        engine.connect(player, to: mixer, format: f.processingFormat)
        player.scheduleFile(f, at: nil) {print("done")}
        engine.prepare()
        do {
            try engine.start()
            player.play()
        } catch {return}
        
        let url2 = Bundle.main().urlForResource("Hooded", withExtension: "mp3")!
        let f2 = try! AVAudioFile(forReading: url2)
        let buffer = AVAudioPCMBuffer(pcmFormat: f2.processingFormat, frameCapacity: UInt32(f2.length/3))
        try! f2.read(into:buffer)
        let player2 = AVAudioPlayerNode()
        engine.attach(player2)
        engine.connect(player2, to: mixer, format: f2.processingFormat)
        player2.scheduleBuffer(buffer, at: nil, options: .loops)
        // mix down a little
        player2.volume = 0.5
        player2.play()
    }
    

    
    @IBAction func doButton4(_ sender: AnyObject) {
        engine.stop()
        
        // first sound
        let player = AVAudioPlayerNode()
        let url = Bundle.main().urlForResource("aboutTiagol", withExtension: "m4a")!
        let f = try! AVAudioFile(forReading: url)
        engine.attach(player)

        // add some effect nodes to the chain
        let effect = AVAudioUnitTimePitch()
        effect.rate = 0.9
        effect.pitch = -300
        engine.attach(effect)
        engine.connect(player, to: effect, format: f.processingFormat)
        let effect2 = AVAudioUnitReverb()
        effect2.loadFactoryPreset(.cathedral)
        effect2.wetDryMix = 40
        engine.attach(effect2)
        engine.connect(effect, to: effect2, format: f.processingFormat)
        
        // patch last node into engine mixer and start playing first sound
        let mixer = engine.mainMixerNode
        engine.connect(effect2, to: mixer, format: f.processingFormat)
        player.scheduleFile(f, at: nil) {print("done")}
        engine.prepare()
        do {
            try engine.start()
            player.play()
        } catch { return }
        
        // second sound; loop it this time
        let url2 = Bundle.main().urlForResource("Hooded", withExtension: "mp3")!
        let f2 = try! AVAudioFile(forReading: url2)
        let buffer = AVAudioPCMBuffer(pcmFormat: f2.processingFormat, frameCapacity: UInt32(f2.length/3))
        try! f2.read(into:buffer)
        let player2 = AVAudioPlayerNode()
        engine.attach(player2)
        engine.connect(player2, to: mixer, format: f2.processingFormat)
        player2.scheduleBuffer(buffer, at: nil, options: .loops)
        
        // mix down a little, start playing second sound
        player.pan = -0.5
        player2.volume = 0.5
        player2.pan = 0.5
        player2.play()
        
        print(player.volume)
    }
    
    // new iOS 9 feature: split node
    
    @IBAction func doButton4a(_ sender: AnyObject) {
        engine.stop()
        
        // first sound
        let player = AVAudioPlayerNode()
        let url = Bundle.main().urlForResource("aboutTiagol", withExtension: "m4a")!
        let f = try! AVAudioFile(forReading: url)
        engine.attach(player)
        
        // add some effect nodes to the chain
        let effect = AVAudioUnitDelay()
        effect.delayTime = 0.4
        effect.feedback = 0
        engine.attach(effect)
        let effect2 = AVAudioUnitReverb()
        effect2.loadFactoryPreset(.cathedral)
        effect2.wetDryMix = 40
        engine.attach(effect2)
        
        let mixer = engine.mainMixerNode

        // patch player node to _both_ effect nodes _and_ the mixer
        let cons = [
            AVAudioConnectionPoint(node: effect, bus: 0),
            AVAudioConnectionPoint(node: effect2, bus: 0),
            AVAudioConnectionPoint(node: mixer, bus: 1),
        ]
        engine.connect(player, to: cons, fromBus: 0, format: f.processingFormat)
        
        // patch both effect nodes into the mixer
        engine.connect(effect, to: mixer, format: f.processingFormat)
        engine.connect(effect2, to: mixer, format: f.processingFormat)
        player.scheduleFile(f, at: nil) {print("done")}
        engine.prepare()
        do {
            try engine.start()
            player.play()
        } catch { return }
        
        print(player.volume)
    }

    
    @IBAction func doButton5(_ sender: AnyObject) {
        engine.stop()
        
        // simple minimal file-writing example
        // not difficult, but you have to form a valid file format or you'll get an error up front
        // also, it's a little disappointing to find that you must _play_ the sound...
        // you can't just process it directly into a file, which is what I was hoping to do
        
        let url2 = Bundle.main().urlForResource("Hooded", withExtension: "mp3")!
        let f2 = try! AVAudioFile(forReading: url2)
        let buffer = AVAudioPCMBuffer(pcmFormat: f2.processingFormat, frameCapacity: UInt32(f2.length/3)) // only need 1/3 of the original recording
        try! f2.read(into:buffer)
        
        let player2 = AVAudioPlayerNode()
        engine.attach(player2)
        
        let effect = AVAudioUnitReverb()
        effect.loadFactoryPreset(.cathedral)
        effect.wetDryMix = 40
        engine.attach(effect)
        
        engine.connect(player2, to: effect, format: f2.processingFormat)
        let mixer = engine.mainMixerNode
        engine.connect(effect, to: mixer, format: f2.processingFormat)

        // create the output file

        let fm = FileManager.default()
        let doc = try! fm.urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let outurl = try! doc.appendingPathComponent("myfile.aac", isDirectory:false)
        
        let outfile = try! AVAudioFile(forWriting: outurl, settings: [
            AVFormatIDKey : NSNumber(value:kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey : 1,
            AVSampleRateKey : 22050,
            AVEncoderBitRatePerChannelKey : 16
            ])
        
        // we'll know when the input buffer is emptied, but the sound will still be going on
        // because of the reverb; so to detect when the sound has faded away,
        // we watch for the last output buffer value to become very small
        
        // install a tap on the reverb effect node
        var done = false // flag: don't stop until input buffer is empty!
        effect.installTap(onBus:0, bufferSize: 4096, format: outfile.processingFormat) {
            (buffer : AVAudioPCMBuffer!, time : AVAudioTime!) in
            let dataptrptr = buffer.floatChannelData!
            let dataptr = dataptrptr.pointee
            let datum = dataptr[Int(buffer.frameLength) - 1]
            // stop when input is empty and sound is very quiet
            if done && fabs(datum) < 0.000001 {
                print("stopping")
                self.engine.stop()
                return
            }
            do {
                try outfile.write(from:buffer)
            } catch {
                print(error)
            }
        }
        player2.scheduleBuffer(buffer) {
            done = true
        }

        engine.prepare()
        do {
            try engine.start()
            player2.play()
        } catch {}
    }

    
    @IBAction func doStop(_ sender: AnyObject) {
        engine.stop()
        engine.reset()
    }
}

