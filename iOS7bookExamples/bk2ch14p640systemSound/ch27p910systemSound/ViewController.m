

#import "ViewController.h"
@import AudioToolbox;

@interface ViewController ()

@end

@implementation ViewController

void SoundFinished (SystemSoundID snd, void* context) {
    // NSLog(@"finished!");
    AudioServicesRemoveSystemSoundCompletion(snd);
    AudioServicesDisposeSystemSoundID(snd);
}

- (IBAction)doButton:(id)sender {
    NSURL* sndurl = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"aif"];
    SystemSoundID snd;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sndurl, &snd);
    AudioServicesAddSystemSoundCompletion(snd, nil, nil, SoundFinished, nil);
    AudioServicesPlaySystemSound(snd);
}



@end
