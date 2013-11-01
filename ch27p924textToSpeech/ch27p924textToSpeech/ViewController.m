

#import "ViewController.h"
@import AVFoundation;

@interface ViewController () <AVSpeechSynthesizerDelegate>
@property (nonatomic, strong) AVSpeechSynthesizer* talker;
@end

@implementation ViewController

- (IBAction)talk:(id)sender {
    AVSpeechUtterance* utter = [[AVSpeechUtterance alloc] initWithString:@"Polly, want a cracker?"];
    // NSLog(@"%@", [AVSpeechSynthesisVoice speechVoices]);
    AVSpeechSynthesisVoice* v = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utter.voice = v;
    CGFloat rate = AVSpeechUtteranceMaximumSpeechRate - AVSpeechUtteranceMinimumSpeechRate;
    rate = rate * 0.3 + AVSpeechUtteranceMinimumSpeechRate;
    utter.rate = rate;
    if (!self.talker)
        self.talker = [AVSpeechSynthesizer new];
    self.talker.delegate = self;
    [self.talker speakUtterance:utter];
}

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"%@", @"starting");
}

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"%@", @"finished");
}

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance {
    NSLog(@"about to say %@", [utterance.speechString substringWithRange:characterRange]);
}


@end
