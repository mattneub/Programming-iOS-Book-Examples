

import UIKit
import AVFoundation

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    var talker = AVSpeechSynthesizer()

    @IBAction func talk (sender:AnyObject!) {
        let utter = AVSpeechUtterance(string:"Polly, want a cracker?")
        // print(AVSpeechSynthesisVoice.speechVoices())
        let v = AVSpeechSynthesisVoice(language: "en-US")
        utter.voice = v
//        var rate = AVSpeechUtteranceMaximumSpeechRate - AVSpeechUtteranceMinimumSpeechRate
//        rate = rate * 0.15 + AVSpeechUtteranceMinimumSpeechRate
//        utter.rate = rate
        self.talker.delegate = self
        self.talker.speakUtterance(utter)
        
        print(v?.identifier)
        print(v?.quality.rawValue)
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        print("starting")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        print("finished")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let s = (utterance.speechString as NSString).substringWithRange(characterRange)
        print("about to say \(s)")
    }
    
    


}
