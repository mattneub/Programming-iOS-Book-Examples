

import UIKit

import Speech
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var recLabel: UILabel!
    
    func checkSpeechAuthorization(andThen f: (() -> ())?) {
        print("checking speech authorization")
        let status = SFSpeechRecognizer.authorizationStatus()
        switch status {
        case .notDetermined:
            SFSpeechRecognizer.requestAuthorization {status2 in
                if status2 == .authorized {
					DispatchQueue.main.async {
						f?()
					}
                }
            }
        case .authorized:
            f?()
        default:
            print("no authorization")
            break
        }
    }
    
    func checkMicAuthorization(andThen f: (() -> ())?) {
        print("checking mic authorization")
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
    
    @IBAction func doFile(_ sender: Any) {
        self.checkSpeechAuthorization(andThen:reallyDoFile)
    }
    
    func reallyDoFile() {
        // print(SFSpeechRecognizer.supportedLocales())
        
        let f = Bundle.main.url(forResource: "test", withExtension: "aif")!
        let req = SFSpeechURLRecognitionRequest(url: f)
        let loc = Locale(identifier: "en-US")
        guard let rec = SFSpeechRecognizer(locale:loc)
            else {print("no recognizer"); return}
        print("rec isAvailable says: \(rec.isAvailable)")
        if rec.supportsOnDeviceRecognition {
            print("on device recognition")
            req.requiresOnDeviceRecognition = true
        } else {
            print("no on device recognition")
        }
        print("starting file recognition")
        rec.recognitionTask(with: req) { result, err in
            if let result = result {
                let trans = result.bestTranscription
                let s = trans.formattedString
                print(s)
                if result.isFinal {
                    print("finished!")
                }
            } else {
                print(err!)
            }
        }
        
    }
    
    // NB for live recognition, we also need a microphone usage description key
    
//    lazy var rec : SFSpeechRecognizer! = {
//        let loc = Locale(identifier: "en-US")
//        guard let rec = SFSpeechRecognizer(locale:loc)
//            else {print("no recognizer"); return nil}
//        return rec
//    }()
    let engine = AVAudioEngine()
    let req = SFSpeechAudioBufferRecognitionRequest()
    
    @IBAction func doLive(_ sender: Any) {
        self.checkSpeechAuthorization(andThen:alsoCheckMic)
    }
    
    func alsoCheckMic() {
        self.checkMicAuthorization(andThen:reallyDoLive)
    }
    
    func reallyDoLive() {
        // same as before, basically
        let loc = Locale(identifier: "en-US")
        guard let rec = SFSpeechRecognizer(locale:loc)
            else {print("no recognizer"); return}
        print("rec isAvailable says: \(rec.isAvailable)")
        if rec.supportsOnDeviceRecognition {
            print("on device recognition")
            req.requiresOnDeviceRecognition = true
        } else {
            print("no on device recognition")
        }
        // tap into microphone thru audio engine!
        let input = self.engine.inputNode
        input.installTap(onBus: 0, bufferSize: 4096, format: input.outputFormat(forBus: 0)) {
            buffer, time in
            self.req.append(buffer)
        }
        self.engine.prepare()
        try! self.engine.start()
        self.recLabel.isHidden = false
        // same as before
        print("starting live recognition")
        rec.recognitionTask(with: self.req) { result, err in
            if let result = result {
                let trans = result.bestTranscription
                let s = trans.formattedString
                print(s)
                if result.isFinal {
                    print("finished!")
                }
            } else {
                // with on device recognition I always get error 203 when we stop
                // but I don't think that's of any importance
                print(err!)
                self.recLabel.isHidden = true
            }
        }
    }
    
    // this is why req is a property: we need a way to stop it
    @IBAction func endLive(_ sender: Any) {
        self.engine.stop()
        self.engine.inputNode.removeTap(onBus: 0) // otherwise cannot start again
        self.req.endAudio()
        self.recLabel.isHidden = true
    }
}
