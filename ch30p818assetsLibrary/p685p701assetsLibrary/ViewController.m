

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *iv;
@end

@implementation ViewController

/*
 Well, I realized something I didn't understand previously.
 The use of blocks here is not just a cute enumeration feature;
 these calls are truly asynchronous, returning immediately,
 and you don't know when the blocks will actually be executed.
 And *that* is why you get the extra cycle with the null object;
 it's because if you want to *do* something with the enumerated output,
 now is the first moment you can do that.
 
 */


/*
 In theory, since the library can change in real time,
 there are notifications to detect this, and they are synchronous -
 you get a notification the moment the change happens, possibly between loops thru the enumeration.
 Thus you can check at the top of each enumeration to make sure it's still safe to proceed.

 However, in reality I have not found a way to trigger this notification.
 My test here *never* logs.
 */

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changed:) name:ALAssetsLibraryChangedNotification object:nil];
}

- (void) changed: (NSNotification*) n {
    NSLog(@"%@", n.userInfo);
}

- (IBAction) doGo: (id) sender {
    // what I'll do with the assets from the group
    ALAssetsGroupEnumerationResultsBlock getPix = 
    ^ (ALAsset *result, NSUInteger index, BOOL *stop) {
        if (!result)
            return;
        ALAssetRepresentation* rep = [result defaultRepresentation];
        NSLog(@"%@", rep.filename); // new in iOS 5
        CGImageRef im = [rep fullScreenImage]; //
//        im = result.aspectRatioThumbnail; // ---
//        self->iv.contentMode = UIViewContentModeCenter; // ---
        UIImage* im2 = [UIImage imageWithCGImage:im scale:0 
                                     orientation:(UIImageOrientation)rep.orientation]; //
        self.iv.image = im2; // put image into our UIImageView
        *stop = YES; // got first image, all done
    };
    // what I'll do with the groups from the library
    ALAssetsLibraryGroupsEnumerationResultsBlock getGroups = 
    ^ (ALAssetsGroup *group, BOOL *stop) {
        if (!group)
            return;
        NSString* title = [group valueForProperty: ALAssetsGroupPropertyName];
        if ([title isEqualToString: @"mattBestVertical"]) {
            [group enumerateAssetsUsingBlock:getPix];
            *stop = YES; // got target group, all done
        }
    };
    // might not be able to access library at all
    ALAssetsLibraryAccessFailureBlock oops = ^ (NSError *error) {
        NSLog(@"oops! %@", [error localizedDescription]); 
        // e.g. "Global denied access"
    };
    // and here we go with the actual enumeration!
    // new iOS 6 feature: we can check for access before we start
    // however, we don't really *have* to do this, since, if access is denied...
    // ... we'll get an error in good order when we attempt access
    // (as shown in doTest below)
    ALAuthorizationStatus stat = [ALAssetsLibrary authorizationStatus];
    if (stat == ALAuthorizationStatusDenied || stat == ALAuthorizationStatusRestricted) {
        // in real life, we could put up interface asking for access
        NSLog(@"%@", @"No access");
        return;
    }
    NSLog(@"%@", @"We're off to see the wizard");
    ALAssetsLibrary* library = [ALAssetsLibrary new];
    [library enumerateGroupsWithTypes: ALAssetsGroupAlbum 
                           usingBlock: getGroups
                         failureBlock: oops];
}


- (IBAction)doTest:(id)sender { // just exploring this feature
    ALAssetsLibraryGroupsEnumerationResultsBlock getGroups = 
    ^ (ALAssetsGroup *group, BOOL *stop) {
        if (!group)
            return;
        NSString* title = [group valueForProperty: ALAssetsGroupPropertyName];
        // note that camera roll is not "editable" but we can still write to it, weird
        NSLog(@"%@ editable: %i", title, group.editable);
    };
    
    ALAssetsLibraryAccessFailureBlock oops = ^ (NSError *error) {
        NSLog(@"oops! %@", [error localizedDescription]); 
        // e.g. "Global denied access"
    };
    
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    
    // we can add an album! and if we added it, we can write to it
    // but we cannot delete it, and we cannot delete a photo from it or any other album, weird
    /*
     Here's an interesting thing: when you run this code, enumerateWithGroups happens
     *before* the group is created! This is because group creation is asynchronous;
     it doesn't happen until all other code has stopped running
     and we can re-enter on the main thread
     */
    /*
     OMG *everything* is asynchronous, see note at top
     */
    [library addAssetsGroupAlbumWithName:@"Cool Pix" resultBlock:^(ALAssetsGroup *group) {
        // NB! if we fail to create the group (e.g. because this group exists already)...
        // we *still* enter this block! but the group is null
        NSString* title = [group valueForProperty: ALAssetsGroupPropertyName];
        NSLog(@"created new group %@; editable: %i", title, group.editable);
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [library enumerateGroupsWithTypes: ALAssetsGroupAll
                           usingBlock: getGroups
                         failureBlock: oops];
}


@end
