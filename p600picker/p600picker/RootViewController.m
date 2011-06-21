

#import "RootViewController.h"

@implementation RootViewController
@synthesize states;

-(void)awakeFromNib {
    [super awakeFromNib];
    NSString* s = [[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"];
    s = [NSString stringWithContentsOfFile:s encoding:NSUTF8StringEncoding error:nil];
    self.states = [s componentsSeparatedByString:@"\n"];
}

- (void)dealloc {
    [states release];
    [super dealloc];
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
        lab = [[[UILabel alloc] init] autorelease];
    lab.text = [self.states objectAtIndex:row];
    lab.backgroundColor = [UIColor clearColor];
    [lab sizeToFit];
    return lab;
}


@end
