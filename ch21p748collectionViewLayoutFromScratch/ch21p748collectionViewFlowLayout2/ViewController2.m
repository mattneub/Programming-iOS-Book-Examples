
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

@end
