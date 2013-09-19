

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) NSArray* states;
@end

@implementation RootViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    NSString* s = [[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"];
    s = [NSString stringWithContentsOfFile:s encoding:NSUTF8StringEncoding error:nil];
    self.states = [s componentsSeparatedByString:@"\n"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView 
numberOfRowsInComponent:(NSInteger)component {
    return 50;
}

// (new iOS 6 feature pickerView:attributedTitleForRow:forComponent: not shown here)

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* lab;
    if (view)
        lab = (UILabel*)view;
    else
        lab = [[UILabel alloc] init];
    lab.text = (self.states)[row];
    lab.backgroundColor = [UIColor clearColor];
    [lab sizeToFit];
    return lab;
}


@end
