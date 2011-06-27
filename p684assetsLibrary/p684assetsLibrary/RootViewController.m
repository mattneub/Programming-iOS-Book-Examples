

#import "RootViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation RootViewController
@synthesize iv;

- (void)dealloc
{
    [iv release];
    [super dealloc];
}

// run on device
// change name of album to something you've actually got

- (IBAction) doGo: (id) sender {
    // what I'll do with the assets from the group
    ALAssetsGroupEnumerationResultsBlock getPix = 
    ^ (ALAsset *result, NSUInteger index, BOOL *stop) {
        if (!result)
            return;
        ALAssetRepresentation* rep = [result defaultRepresentation];
        CGImageRef im = [rep fullResolutionImage];
        UIImage* im2 = [UIImage imageWithCGImage:im];
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
    [library release];
}

@end
