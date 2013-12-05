

#import "ViewController.h"
@import AssetsLibrary;

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *iv;
@end

@implementation ViewController


- (IBAction) doGo: (id) sender {
    [self findAlbumWithTitle:@"mattBestHoriz"];
}

- (void) findAlbumWithTitle: (NSString*) albumTitle {
    
    __block ALAssetsGroup* album = nil;
    ALAssetsLibrary* library = [ALAssetsLibrary new];
    [library enumerateGroupsWithTypes: ALAssetsGroupAlbum
                           usingBlock:
     ^ (ALAssetsGroup *group, BOOL *stop) {
         if (group) {
             NSString* title =
             [group valueForProperty: ALAssetsGroupPropertyName];
             if ([title isEqualToString: albumTitle]) {
                 album = group;
                 *stop = YES;
             }
         } else { // afterwards
             if (!album) {
                 NSLog(@"%@", @"failed to find album");
                 return;
             }
             [self showFirstPhotoOfGroup:album];
         }
     }
                         failureBlock:
     ^ (NSError *error) {
         NSLog(@"oops! %@", [error localizedDescription]);
         // e.g. "Global denied access"
     }
     ];
}

- (void) showFirstPhotoOfGroup: (ALAssetsGroup*) group {
    __block ALAsset* photo;
    [group enumerateAssetsUsingBlock:
     ^(ALAsset *result, NSUInteger index, BOOL *stop) {
         if (result) {
             NSString* type = [result valueForProperty:ALAssetPropertyType];
             if ([type isEqualToString: ALAssetTypePhoto]) {
                 photo = result;
                 *stop = YES;
             }
         } else { // afterwards
             if (!photo)
                 return;
//             ALAssetRepresentation* rep = [photo defaultRepresentation];
//             NSLog(@"displaying %@", rep.filename);
//             CGImageRef im = [rep fullScreenImage]; //
             CGImageRef im = photo.aspectRatioThumbnail;
             // self.iv.contentMode = UIViewContentModeCenter; // ---
             UIImage* im2 = [UIImage imageWithCGImage:im scale:0
                                          orientation:UIImageOrientationUp]; //
             self.iv.image = im2; // put image into our UIImageView
         }
     }];
    
}


@end
