

import UIKit
import CoreHaptics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    var feedback : UISelectionFeedbackGenerator? = nil
    @IBAction func doButton1(_ sender: Any) {
        self.feedback = self.feedback ?? UISelectionFeedbackGenerator()
        self.feedback!.prepare()
        DispatchQueue.main.async {
            self.feedback!.selectionChanged()
        }
    }
    
    var engine : CHHapticEngine?
    var player : CHHapticPatternPlayer?
    fileprivate func ensureHapticEngine() {
        if self.engine == nil && CHHapticEngine.capabilitiesForHardware().supportsHaptics {
            let params : [CHHapticEventParameter] = [
                .init(parameterID: .hapticIntensity, value: 0.5),
                .init(parameterID: .hapticSharpness, value: 0.3)
            ]
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: params, relativeTime: 0)
            do {
                let pattern = try CHHapticPattern(events: [event], parameters: [])
                self.engine = try CHHapticEngine()
                self.engine?.playsHapticsOnly = true // reduce latency
                self.player = try self.engine?.makePlayer(with: pattern)
            } catch {
                print(error)
            }
        }
    }
    fileprivate func playHapticPattern() {
        self.engine?.start { err in
            if err == nil {
                do {
                    self.engine?.notifyWhenPlayersFinished { _ in .stopEngine }
                    try self.player?.start(atTime: CHHapticTimeImmediate)
                } catch {
                    print(error)
                }
            }
        }
    }
    @IBAction func doButton2(_ sender: Any) {
        self.ensureHapticEngine()
        self.playHapticPattern()
    }
    
    var engine2 : CHHapticEngine?
    var player2 : CHHapticPatternPlayer?
    fileprivate func ensureHapticEngine2() {
        if self.engine2 == nil && CHHapticEngine.capabilitiesForHardware().supportsHaptics {
            let params : [[CHHapticPattern.Key : Any]] = [
                [
                    .parameterID: CHHapticEvent.ParameterID.hapticSharpness,
                    .parameterValue: 0.7,
                ],
                [
                    .parameterID: CHHapticEvent.ParameterID.hapticIntensity,
                    .parameterValue: 0.8,
                ],
            ]
            typealias patt = [CHHapticPattern.Key : [[CHHapticPattern.Key : [CHHapticPattern.Key : Any]]]]
            let d : patt = [
                .pattern: [
                    [.event: [
                        .eventType: CHHapticEvent.EventType.hapticTransient,
                        .eventParameters: params,
                        .time: 0.0,
                        .eventDuration: 0.1]
                    ],
                    [.event: [
                        .eventType: CHHapticEvent.EventType.hapticTransient,
                        .eventParameters: params,
                        .time: 0.3,
                        .eventDuration: 0.1]
                    ],
                    [.event: [
                        .eventType: CHHapticEvent.EventType.hapticTransient,
                        .eventParameters: params,
                        .time: 0.6,
                        .eventDuration: 0.1]
                    ],
                    [.event: [
                        .eventType: CHHapticEvent.EventType.hapticContinuous,
                        .time: 0.9,
                        .eventDuration: 1.0]
                    ]
                ]
            ]
            do {
                let pattern = try CHHapticPattern(dictionary: d)
                self.engine2 = try CHHapticEngine()
                self.engine2?.playsHapticsOnly = true // reduce latency
                self.player2 = try self.engine2?.makePlayer(with: pattern)
            } catch {
                print(error)
            }
        }
    }
    fileprivate func playHapticPattern2() {
        self.engine2?.start { err in
            if err == nil {
                do {
                    self.engine2?.notifyWhenPlayersFinished { _ in .stopEngine }
                    try self.player2?.start(atTime: CHHapticTimeImmediate)
                } catch {
                    print(error)
                }
            }
        }
    }

    @IBAction func doButton3(_ sender: Any) {
        self.ensureHapticEngine2()
        self.playHapticPattern2()
    }
    

}

