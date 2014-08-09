

#import "SystemSoundHelper.h"

@implementation SystemSoundHelper

void SoundFinished (SystemSoundID snd, void* context) {
    NSLog(@"finished!");
    AudioServicesRemoveSystemSoundCompletion(snd);
    AudioServicesDisposeSystemSoundID(snd);
}

// typedef void (*AudioServicesSystemSoundCompletionProc) ( SystemSoundID ssID, void *clientData );
- (AudioServicesSystemSoundCompletionProc) completionHandler {
    return SoundFinished;
}


@end
