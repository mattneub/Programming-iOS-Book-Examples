
#import "ViewController2.h"
#import "Cell.h"
#import "MyFlowLayout.h"

@interface ViewController2 ()
@end

@implementation ViewController2

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.useLayoutToLayoutNavigationTransitions = YES;
    }
    return self;
}

- (void) setUpFlowLayout: (UICollectionViewFlowLayout*) flow {
    if ([flow isKindOfClass: [UICollectionViewFlowLayout class]]) {
        flow.headerReferenceSize = CGSizeMake(50,50); // * larger - we will place label within this
        flow.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10); // *
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    self.navigationItem.title = @"States 2";
    
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Flush" style:UIBarButtonItemStylePlain target:self action:@selector(doFlush:)];
    self.navigationItem.rightBarButtonItem = b;

    
    //
    // if you don't do something about header size...
    // ...you won't see any headers
    UICollectionViewFlowLayout* flow = (UICollectionViewFlowLayout*)self.collectionViewLayout;
    [self setUpFlowLayout:flow];
    
    [self.collectionView reloadData];
}

- (void) doFlush: (id) sender {
    UICollectionViewLayout* layout = self.collectionView.collectionViewLayout;
    if (![layout isKindOfClass:[MyFlowLayout class]])
        return;
    [(MyFlowLayout*)layout flush];
}

// showing the extremely weird transfer of responsibilities

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"\n%@\n%@", self.collectionView.dataSource, self.collectionView.delegate);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"\n%@\n%@", self.collectionView.dataSource, self.collectionView.delegate);
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"\n%@\n%@", self.collectionView.dataSource, self.collectionView.delegate);
    });
}

// but I don't want to be the delegate, because I need the data for that, and I don't have it!
// so I forward delegation back to the other view controller

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewController* cv = self.navigationController.viewControllers[0];
    if ([cv respondsToSelector:_cmd])
        return [(id<UICollectionViewDelegateFlowLayout>)cv collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    return CGSizeZero;
}


@end
