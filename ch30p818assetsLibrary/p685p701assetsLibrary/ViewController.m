

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ViewController {
    __weak IBOutlet UIImageView *iv;
}

- (IBAction) doGo: (id) sender {
    // what I'll do with the assets from the group
    ALAssetsGroupEnumerationResultsBlock getPix = 
    ^ (ALAsset *result, NSUInteger index, BOOL *stop) {
        if (!result)
            return;
        ALAssetRepresentation* rep = [result defaultRepresentation];
        // NSLog(@"%@", rep.filename); // new in iOS 5
        CGImageRef im = [rep fullScreenImage]; //
//        im = result.aspectRatioThumbnail; // ---
//        self->iv.contentMode = UIViewContentModeCenter; // ---
        UIImage* im2 = [UIImage imageWithCGImage:im scale:0 
                                     orientation:(UIImageOrientation)rep.orientation]; //
        [self->iv setImage:im2]; // put image into our UIImageView
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
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes: ALAssetsGroupAlbum 
                           usingBlock: getGroups
                         failureBlock: oops];
}


- (IBAction)doTest:(id)sender { // just exploring this new feature
    ALAssetsLibraryGroupsEnumerationResultsBlock getGroups = 
    ^ (ALAssetsGroup *group, BOOL *stop) {
        if (!group)
            return;
        NSString* title = [group valueForProperty: ALAssetsGroupPropertyName];
        NSLog(@"%@ %i", title, group.editable);
    };
    ALAssetsLibraryAccessFailureBlock oops = ^ (NSError *error) {
        NSLog(@"oops! %@", [error localizedDescription]); 
        // e.g. "Global denied access"
    };
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
//    [library addAssetsGroupAlbumWithName:@"Cool Pix" resultBlock:^(ALAssetsGroup *group) {
//        NSLog(@"editable: %i", group.editable);
//    } failureBlock:^(NSError *error) {
//        NSLog(@"error");
//    }];
    [library enumerateGroupsWithTypes: ALAssetsGroupAll 
                           usingBlock: getGroups
                         failureBlock: oops];
}


@end
