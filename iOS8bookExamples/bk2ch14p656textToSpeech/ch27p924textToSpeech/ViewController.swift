

import UIKit
import AVFoundation

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    var talker = AVSpeechSynthesizer()

    @IBAction func talk (sender:AnyObject!) {
        let utter = AVSpeechUtterance(string:"Polly, want a cracker?")
        // println(AVSpeechSynthesisVoice.speechVoices())
        let v = AVSpeechSynthesisVoice(language: "en-US")
        utter.voice = v
        var rate = AVSpeechUtteranceMaximumSpeechRate - AVSpeechUtteranceMinimumSpeechRate
        rate = rate * 0.15 + AVSpeechUtteranceMinimumSpeechRate
        utter.rate = rate
        self.talker.delegate = self
        self.talker.speakUtterance(utter)
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didStartSpeechUtterance utterance: AVSpeechUtterance!) {
        println("starting")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        println("finished")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance!) {
        let s = (utterance.speechString as NSString).substringWithRange(characterRange)
        println("about to say \(s)")
    }
    
    


}
