
#import "RootViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation RootViewController

void SoundFinished (SystemSoundID snd, void* context) {
    // NSLog(@"finished!");
    AudioServicesRemoveSystemSoundCompletion(snd);
    AudioServicesDisposeSystemSoundID(snd);
}

- (IBAction)doButton:(id)sender {
    NSURL* sndurl = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"aif"];
    SystemSoundID snd;
    AudioServicesCreateSystemSoundID((CFURLRef)sndurl, &snd);
    AudioServicesAddSystemSoundCompletion(snd, NULL, NULL, &SoundFinished, NULL);
    AudioServicesPlaySystemSound(snd);
}



@end
