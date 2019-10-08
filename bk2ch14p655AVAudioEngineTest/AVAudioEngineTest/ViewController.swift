

import UIKit
import AVFoundation

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

// warning: turn off your "All Exceptions" breakpoint

class ViewController: UIViewController {
    
    var audioPlayer : AVAudioPlayer!
    
    var engine = AVAudioEngine()
    
    @IBAction func doButton(_ sender: Any) {
        self.engine.stop()
        self.engine = AVAudioEngine()
        
        // simplest possible "play a file" scenario
        // construct a graph
        // take out a player node
        let player = AVAudioPlayerNode()
        // open a file to play on the player node
        let url = Bundle.main.url(forResource:"aboutTiagol", withExtension:"m4a")!
        let f = try! AVAudioFile(forReading: url)
        // hook the player's output to the self.engine's mixer node
        // alternatively, could use the self.engine's output node (mixer is hooked to output already)
        let mixer = self.engine.mainMixerNode
        self.engine.attach(player)
        self.engine.connect(player, to: mixer, format: f.processingFormat)
        // schedule the file on the player
        player.scheduleFile(f, at: nil) {
            print("stopping")
            // delay because otherwise we can get exclusive access issues
            delay(0.1) {
                if self.engine.isRunning {
                    print("engine was running, really stopping")
                    self.engine.stop()
                }
            }
        }
        // start the self.engine
        self.engine.prepare()
        try! self.engine.start()
        player.play()
    }

    
    @IBAction func doButton2(_ sender: Any) {
        self.engine.stop()
        self.engine = AVAudioEngine()
        
        // simplest possible "play a buffer" scenario
        let url2 = Bundle.main.url(forResource:"Hooded", withExtension: "mp3")!
        let f2 = try! AVAudioFile(forReading: url2)
        let buffer = AVAudioPCMBuffer(pcmFormat: f2.processingFormat, frameCapacity: UInt32(f2.length /* /3 */)) // only need 1/3 of the original recording
        try! f2.read(into:buffer!)
        
        let player2 = AVAudioPlayerNode()
        self.engine.attach(player2)
        let mixer = self.engine.mainMixerNode
        self.engine.connect(player2, to: mixer, format: f2.processingFormat)

        player2.scheduleBuffer(buffer!) {
            print("stopping")
            // delay because otherwise we can get exclusive access issues
            delay(0.1) {
                if self.engine.isRunning {
                    print("engine was running, really stopping")
                    self.engine.stop()
                }
            }
        }
        
        self.engine.prepare()
        
        try! self.engine.start()
        player2.play()
    }
    


    @IBAction func doButton3(_ sender: Any) {
        self.engine.stop()
        self.engine = AVAudioEngine()
        
        let player = AVAudioPlayerNode()
        let url = Bundle.main.url(forResource:"aboutTiagol", withExtension: "m4a")!
        let f = try! AVAudioFile(forReading: url)
        let mixer = self.engine.mainMixerNode
        self.engine.attach(player)
        self.engine.connect(player, to: mixer, format: f.processingFormat)
        player.scheduleFile(f, at: nil) {
            print("stopping")
            // delay because otherwise we can get exclusive access issues
            delay(0.1) {
                if self.engine.isRunning {
                    print("engine was running, really stopping")
                    self.engine.stop()
                }
            }
        }
        self.engine.prepare()
        try! self.engine.start()
        player.play()
        
        let url2 = Bundle.main.url(forResource:"Hooded", withExtension: "mp3")!
        let f2 = try! AVAudioFile(forReading: url2)
        let buffer = AVAudioPCMBuffer(pcmFormat: f2.processingFormat, frameCapacity: UInt32(f2.length/3))
        try! f2.read(into:buffer!)
        let player2 = AVAudioPlayerNode()
        self.engine.attach(player2)
        self.engine.connect(player2, to: mixer, format: f2.processingFormat)
        player2.scheduleBuffer(buffer!, at: nil, options: .loops)
        // mix down a little
        player2.volume = 0.5
        player2.play()
    }
    

    
    @IBAction func doButton4(_ sender: Any) {
        self.engine.stop()
        self.engine = AVAudioEngine()
        
        // first sound
        let player = AVAudioPlayerNode()
        let url = Bundle.main.url(forResource:"aboutTiagol", withExtension: "m4a")!
        let f = try! AVAudioFile(forReading: url)
        self.engine.attach(player)

        // add some effect nodes to the chain
        let effect = AVAudioUnitTimePitch()
        effect.rate = 0.9
        effect.pitch = -300
        self.engine.attach(effect)
        self.engine.connect(player, to: effect, format: f.processingFormat)
        let effect2 = AVAudioUnitReverb()
        effect2.loadFactoryPreset(.cathedral)
        effect2.wetDryMix = 40
        self.engine.attach(effect2)
        self.engine.connect(effect, to: effect2, format: f.processingFormat)
        
        // patch last node into self.engine mixer and start playing first sound
        let mixer = self.engine.mainMixerNode
        self.engine.connect(effect2, to: mixer, format: f.processingFormat)
        player.scheduleFile(f, at: nil) {
            print("stopping")
            // delay because otherwise we can get exclusive access issues
            delay(0.1) {
                if self.engine.isRunning {
                    print("engine was running, really stopping")
                    self.engine.stop()
                }
            }
        }
        self.engine.prepare()
        try! self.engine.start()
        player.play()
        
        // second sound; loop it this time
        let url2 = Bundle.main.url(forResource:"Hooded", withExtension: "mp3")!
        let f2 = try! AVAudioFile(forReading: url2)
        let buffer = AVAudioPCMBuffer(pcmFormat: f2.processingFormat, frameCapacity: UInt32(f2.length /* /3 */))
        try! f2.read(into:buffer!)
        let player2 = AVAudioPlayerNode()
        self.engine.attach(player2)
        self.engine.connect(player2, to: mixer, format: f2.processingFormat)
        player2.scheduleBuffer(buffer!, at: nil, options: .loops)

        // mix down a little, start playing second sound
        player.pan = -0.5
        player2.volume = 0.5
        player2.pan = 0.5
        player2.play()
        
        print(player.volume)
    }
    
    // new iOS 9 feature: split node
    
    @IBAction func doButton4a(_ sender: Any) {
        self.engine.stop()
        self.engine = AVAudioEngine()
        
        // first sound
        let player = AVAudioPlayerNode()
        let url = Bundle.main.url(forResource:"aboutTiagol", withExtension: "m4a")!
        let f = try! AVAudioFile(forReading: url)
        self.engine.attach(player)
        
        // add some effect nodes to the chain
        let effect = AVAudioUnitDelay()
        effect.delayTime = 0.4
        effect.feedback = 0
        self.engine.attach(effect)
        let effect2 = AVAudioUnitReverb()
        effect2.loadFactoryPreset(.cathedral)
        effect2.wetDryMix = 40
        self.engine.attach(effect2)
        
        let mixer = self.engine.mainMixerNode

        // patch player node to _both_ effect nodes _and_ the mixer
        let cons = [
            AVAudioConnectionPoint(node: effect, bus: 0),
            AVAudioConnectionPoint(node: effect2, bus: 0),
            AVAudioConnectionPoint(node: mixer, bus: 1),
        ]
        self.engine.connect(player, to: cons, fromBus: 0, format: f.processingFormat)
        
        // patch both effect nodes into the mixer
        self.engine.connect(effect, to: mixer, format: f.processingFormat)
        self.engine.connect(effect2, to: mixer, format: f.processingFormat)
        player.scheduleFile(f, at: nil) {
            print("stopping")
            // delay because otherwise we can get exclusive access issues
            delay(0.1) {
                if self.engine.isRunning {
                    print("engine was running, really stopping")
                    self.engine.stop()
                }
            }
        }
        self.engine.prepare()
        try! self.engine.start()
        player.play()
        
        print(player.volume)
    }

    
    @IBAction func doButton5(_ sender: Any) {
        // simple minimal file-writing example
        // not difficult, but you have to form a valid file format or you'll get an error up front
        // Ooooh news flash! in iOS 11, you can process directly to a file ("offline" rendering)
        
        self.engine.stop()
        self.engine = AVAudioEngine()
        
        let url = Bundle.main.url(forResource:"Hooded", withExtension: "mp3")!
        let f = try! AVAudioFile(forReading: url)
        
        let player = AVAudioPlayerNode()
        self.engine.attach(player)
        
        let effect = AVAudioUnitReverb()
        effect.loadFactoryPreset(.cathedral)
        effect.wetDryMix = 40
        self.engine.attach(effect)
        
        self.engine.connect(player, to: effect, format: f.processingFormat)
        let mixer = self.engine.mainMixerNode
        self.engine.connect(effect, to: mixer, format: f.processingFormat)

        
        let fm = FileManager.default
        let doc = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let outurl = doc.appendingPathComponent("myfile.aac", isDirectory:false)
        try? fm.removeItem(at: outurl) // just in case
        let outfile = try! AVAudioFile(forWriting: outurl, settings: [
            AVFormatIDKey : kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey : 1,
            AVSampleRateKey : 22050,
        ])
        
        var done = false
        player.scheduleFile(f, at: nil) {
            done = true
        }


        let sz : UInt32 = 4096
        try! self.engine.enableManualRenderingMode(.offline, format: f.processingFormat, maximumFrameCount: sz)

        self.engine.prepare()
        try! self.engine.start()
        player.play()
        
        // nothing happens: we have to "pull" the buffer by looping
        // how to know when to end? I can think of two ways
        
        let outbuf = AVAudioPCMBuffer(pcmFormat: f.processingFormat, frameCapacity: sz)!
        
        var which : Int { return 2 }
        switch which {
        case 1:
            // arbitrarily append two seconds of processing time to allow reverb to fade
            let sec = Int64(f.processingFormat.sampleRate)
            var rest : Int64 { return sec*2 + f.length - self.engine.manualRenderingSampleTime }
            while rest > 0 {
                let ct = min(outbuf.frameCapacity, UInt32(rest))
                print(ct)
                let stat = try! self.engine.renderOffline(ct, to: outbuf)
                if stat == .success {
                    print("writing")
                    try! outfile.write(from: outbuf)
                }
            }
        case 2:
            // wait until buffer is very quiet
            while true {
                let ct = outbuf.frameCapacity
                let stat = try! self.engine.renderOffline(ct, to: outbuf)
                if stat == .success {
                    print("writing")
                    try! outfile.write(from: outbuf)
                    
                    let dataptrptr = outbuf.floatChannelData!
                    let dataptr = dataptrptr.pointee
                    let datum = abs(dataptr[Int(outbuf.frameLength)-1])
                    print(datum)
                    if datum < 0.00001 && done {
                        break
                    }
                }
            }
        default: break
        }
        

        player.stop()
        engine.stop()
        // might as well play the resulting file just so we hear what we've got
        self.playSound(outurl)

    }

    
    @IBAction func doStop(_ sender: Any) {
        self.engine.stop()
        self.engine = AVAudioEngine()
    }
    
    func playSound(_ url:URL) {
        do {
            try self.audioPlayer = AVAudioPlayer(contentsOf: url)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
            self.audioPlayer.delegate = self
            print("starting to play?")
            print(self.audioPlayer.duration)
        } catch { print("failed to create audio player from \(url)") }
    }
}

extension ViewController : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished")
    }

}

