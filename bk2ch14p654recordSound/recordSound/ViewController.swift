

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func checkMicAuthorization(andThen f: (() -> ())?) {
        print("checking mic authorization")
        // different names from all other authorizations, sheesh
        let sess = AVAudioSession.sharedInstance()
        let status = sess.recordPermission
        switch status {
        case .undetermined:
            sess.requestRecordPermission {ok in
                if ok {
                    DispatchQueue.main.async {
                        f?()
                    }
                }
            }
        case .granted:
            f?()
        default:
            print("no microphone")
            break
        }
    }

    @IBAction func doStart(_ sender: Any) {
//        reallyDoStart() // skip authorization; yep, that works
//        return;
        self.checkMicAuthorization(andThen:reallyDoStart)
    }
    var recorder : AVAudioRecorder?
    let recurl : URL = {
        let temp = FileManager.default.temporaryDirectory
        return temp.appendingPathComponent("rec.m4a")
    }()
    func reallyDoStart() {
        try? AVAudioSession.sharedInstance().setCategory(.record, mode:.default)
        try? AVAudioSession.sharedInstance().setActive(true)
        let format = AVAudioFormat(settings: [
            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey : 44100.0,
            AVEncoderBitRateKey : 192000,
            AVNumberOfChannelsKey : 2
        ])
        guard format != nil else { return }
        do {
            print("making recorder")
            let rec = try AVAudioRecorder(url:self.recurl, format:format!)
            self.recorder = rec
            print("recording")
            rec.record(forDuration: 10)
        } catch {
            print("oops")
        }
    }
    var player : AVAudioPlayer?
    @IBAction func doStop(_ sender: Any) {
        print("stopping")
        self.recorder?.stop()
        print("playing")
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode:.default)
        try? AVAudioSession.sharedInstance().setActive(true)
        try? self.player = AVAudioPlayer(contentsOf: self.recurl)
        self.player?.prepareToPlay()
        self.player?.play()
        print(self.player?.format.formatDescription as Any)
    }
    
}

