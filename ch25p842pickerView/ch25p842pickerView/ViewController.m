

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (nonatomic, strong) NSArray* states;
@end

@implementation ViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    NSString* s = [[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"];
    s = [NSString stringWithContentsOfFile:s encoding:NSUTF8StringEncoding error:nil];
    self.states = [s componentsSeparatedByString:@"\n"];
    // self.picker.backgroundColor = [UIColor clearColor];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return 50;
}


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

-(void)viewDidLayoutSubviews {
    NSLog(@"%f", self.picker.frame.size.height);
}


@end
