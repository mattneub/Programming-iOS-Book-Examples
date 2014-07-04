
#import "MyPage.h"

@interface MyPage ()
@property (weak, nonatomic) IBOutlet UILabel *lab;
@end

@implementation MyPage

- (void) viewDidLoad {
    [super viewDidLoad];
    self.lab.text = [NSString stringWithFormat:@"%ld",(long)self.num];
}

- (void) setNum: (NSInteger) newNum {
    _num = newNum;
    self.lab.text = [NSString stringWithFormat:@"%ld",(long)newNum];
}

@end
