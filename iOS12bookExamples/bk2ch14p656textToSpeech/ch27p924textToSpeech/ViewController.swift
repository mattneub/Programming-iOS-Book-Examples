

import UIKit
import AVFoundation

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    var talker = AVSpeechSynthesizer()

    @IBAction func talk (_ sender: Any!) {
        var utter = AVSpeechUtterance(string:"Polly, want a cracker?")
        skip: do {
            break skip
            // not very satisfying
            let mas = NSMutableAttributedString(string:"Polly, want a cracker?")
            let key = NSAttributedString.Key(rawValue: AVSpeechSynthesisIPANotationAttribute)
            let s = mas.string as NSString
            mas.addAttribute(key, value: "krækö", range: s.range(of:"cracker"))
            utter = AVSpeechUtterance(attributedString: mas)
        }
        do {
            let arr = AVSpeechSynthesisVoice.speechVoices()
            for v in arr { print(v.name, v.identifier, v.language, v.quality.rawValue) }
        }
        do {
            let v = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)
            print(v as Any)
        }
        if let v = AVSpeechSynthesisVoice(language: "en-US") {
            utter.voice = v
//            var rate =
//                AVSpeechUtteranceMaximumSpeechRate - AVSpeechUtteranceMinimumSpeechRate
//            rate = rate * 0.15 + AVSpeechUtteranceMinimumSpeechRate
//            utter.rate = rate
            // self.talker = AVSpeechSynthesizer()
            self.talker.delegate = self
            self.talker.speak(utter)
            
            print(v.identifier as Any)
            print(v.quality.rawValue as Any)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("starting")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("finished")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let s = (utterance.speechString as NSString).substring(with:characterRange)
        print("about to say \(s)")
    }
    
    


}
