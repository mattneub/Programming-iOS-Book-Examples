
#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@implementation ViewController 

- (void) play {
    // warning: all error checking has been omitted from this example
    // you'd be crazy to do that in real life

    // this first part mostly taken from Apple's LoadPresetDemo example
    
    // ==========
    
    // set up audio session
    
    AVAudioSession *mySession = [AVAudioSession sharedInstance];
    
    [mySession setCategory: AVAudioSessionCategoryPlayback error:nil];
    
    Float64 graphSampleRate = 44100.0;
    
    [mySession setPreferredSampleRate: graphSampleRate error: nil]; // changed, iOS 6 deprecation
    [mySession setActive: YES error:nil];

    
    // ==========
    
    // form the graph: AUSampler -> speakers
    
    AUGraph graph;
	NewAUGraph(&graph);
    	
	// output device (speakers)
	AudioComponentDescription cd = {0};
	cd.componentType = kAudioUnitType_Output;
	cd.componentSubType = kAudioUnitSubType_RemoteIO;
	cd.componentManufacturer = kAudioUnitManufacturer_Apple;
	// adds a node with above description to the graph
	AUNode ioNode;
	AUGraphAddNode(graph, &cd, &ioNode);
    
    // AUSampler
	cd.componentType = kAudioUnitType_MusicDevice ;
	cd.componentSubType = kAudioUnitSubType_Sampler;
	cd.componentManufacturer = kAudioUnitManufacturer_Apple;
	AUNode samplerNode;
	AUGraphAddNode(graph, &cd, &samplerNode);
    
    // Dynamics Proc
    cd.componentType = kAudioUnitType_Effect;
    cd.componentSubType = kAudioUnitSubType_DynamicsProcessor;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    AUNode procNode;
    AUGraphAddNode(graph, &cd, &procNode);


    AUGraphOpen(graph);
    //AUGraphConnectNodeInput(graph, samplerNode, 0, ioNode, 0);
    AUGraphConnectNodeInput(graph, samplerNode, 0, procNode, 0);
    AUGraphConnectNodeInput(graph, procNode, 0, ioNode, 0);
    
    AudioUnit samplerUnit;
    AudioUnit ioUnit;
    AUGraphNodeInfo(graph, samplerNode, 0, &samplerUnit);
    AUGraphNodeInfo(graph, ioNode, 0, &ioUnit);
    
    
    AudioUnit procUnit;
    AUGraphNodeInfo(graph, procNode, 0, &procUnit);
    
    
    // ==========
    
    // configure the audio units; initialize and "start" the graph
    
    
    // AudioUnitInitialize (ioUnit);
    
    AudioUnitInitialize(procUnit);
    AudioUnitSetParameter(procUnit, kDynamicsProcessorParam_MasterGain, kAudioUnitScope_Global
                          , 0, 12, 0);
    AudioUnitSetParameter(procUnit, kDynamicsProcessorParam_ExpansionRatio, kAudioUnitScope_Global
                          , 0, 10, 0);
    
    // next bit unnecessary, omitted for sake of example
    
    /*
     OSStatus result = noErr;
     UInt32 framesPerSlice = 0;
     UInt32 framesPerSlicePropertySize = sizeof (framesPerSlice);
     UInt32 sampleRatePropertySize = sizeof (graphSampleRate);

     
    // Set the I/O unit's output sample rate.
    AudioUnitSetProperty (
                          ioUnit,
                          kAudioUnitProperty_SampleRate,
                          kAudioUnitScope_Output,
                          0,
                          &graphSampleRate,
                          sampleRatePropertySize
                          );
        
    // Obtain the value of the maximum-frames-per-slice from the I/O unit.
    AudioUnitGetProperty (
                          ioUnit,
                          kAudioUnitProperty_MaximumFramesPerSlice,
                          kAudioUnitScope_Global,
                          0,
                          &framesPerSlice,
                          &framesPerSlicePropertySize
                          );
    
    
    // Set the Sampler unit's output sample rate.
    AudioUnitSetProperty (
                          samplerUnit,
                          kAudioUnitProperty_SampleRate,
                          kAudioUnitScope_Output,
                          0,
                          &graphSampleRate,
                          sampleRatePropertySize
                          );
    
    
    // Set the Sampler unit's maximum frames-per-slice.
    AudioUnitSetProperty (
                          samplerUnit,
                          kAudioUnitProperty_MaximumFramesPerSlice,
                          kAudioUnitScope_Global,
                          0,
                          &framesPerSlice,
                          framesPerSlicePropertySize
                          );
    */
    
    
        
    AUGraphInitialize (graph);
    
    AUGraphStart (graph);
    
    // CAShow (graph); 
    
    // ========
    
    // load the sampled sound!
    // convert to data, load as property list, assign to class info property of sampler unit
    
    NSURL *presetURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Trombone" ofType:@"aupreset"]];

	CFDataRef propertyResourceData = 0;
	
	// Read from the URL and convert into a CFData chunk
	CFURLCreateDataAndPropertiesFromResource (
                                               kCFAllocatorDefault,
                                               (__bridge CFURLRef) presetURL,
                                               &propertyResourceData,
                                               nil,
                                               nil,
                                               nil
                                               );
    
   	
	// Convert the data object into a property list
	CFPropertyListRef presetPropertyList = 0;
	CFPropertyListFormat dataFormat = 0;
	presetPropertyList = CFPropertyListCreateWithData (
                                                       kCFAllocatorDefault,
                                                       propertyResourceData,
                                                       kCFPropertyListImmutable,
                                                       &dataFormat,
                                                       nil
                                                       );
    
    // Set the class info property for the Sampler unit using the property list as the value.
		
    AudioUnitSetProperty(
                          samplerUnit,
                          kAudioUnitProperty_ClassInfo,
                          kAudioUnitScope_Global,
                          0,
                          &presetPropertyList,
                          sizeof(CFPropertyListRef)
                          );
    
    CFRelease(presetPropertyList);
    
	CFRelease (propertyResourceData);
    
    // ==============
    // play the midi file
    
    MusicPlayer p;
    MusicSequence s;

    
    NewMusicPlayer(&p);
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"presto" withExtension:@"mid"];
    
    NewMusicSequence(&s);
    MusicSequenceFileLoad(s, (__bridge CFURLRef)url, 0,0);
        
    MusicTrack t;
    MusicTimeStamp len;
    UInt32 sz = sizeof(MusicTimeStamp);
    MusicSequenceGetIndTrack(s, 0, &t);
    MusicTrackGetProperty(t, kSequenceTrackProperty_TrackLength, &len, &sz);
    
    // this is it, arthur pewty! feed the track to the ausampler and let 'er rip
    MusicSequenceSetAUGraph(s, graph);
    //MusicTrackSetDestNode(t, samplerNode);
    

    MusicPlayerSetSequence(p, s);
    MusicPlayerPreroll(p);
    MusicPlayerStart(p);
    while (1) {
        usleep (3 * 1000 * 1000);
        MusicTimeStamp now = 0;
		MusicPlayerGetTime (p, &now);
        if (now >= len)
            break;
        NSLog(@"%f", now);
    }
    
    NSLog(@"finishing");
    
    // shut everything down in good order
    AUGraphStop(graph);
    MusicPlayerStop(p);
    DisposeAUGraph(graph);
    DisposeMusicSequence(s);
    DisposeMusicPlayer(p);
    [mySession setActive: NO error:nil];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_queue_t q = dispatch_get_global_queue(0,0);
    dispatch_async(q, ^{
        [self play];
    });
}

- (IBAction) doButton: (id) sender {
    NSLog(@"This button doesn't do anything.");
}

@end
