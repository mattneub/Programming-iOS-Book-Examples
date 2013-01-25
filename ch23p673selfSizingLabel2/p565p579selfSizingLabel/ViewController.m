

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UILabel *lab2;

@end

@implementation ViewController 

/*
 In iOS 6, a whole 'nother way of sizing the label vertically to fit its contents:
 use constraints! All the work can be done right in the nib.
 The label has no height constraint so it is free to obey its intrinsic content size.
 I show two ways of fixing the width: with a width constraint, and with the 
 preferredMaxLayoutWidth
 */

/* also, rotate the app */

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // delay is to prove that this will work any time while the app runs
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self doYourThing];
    });

}

- (void) doYourThing {
    NSLog(@"%f", self.lab.bounds.size.width);
    
    NSString* s2 = @"Fourscore and seven years ago, our fathers brought forth "
    @"upon this continent a new nation, conceived in liberty and dedicated "
    @"to the proposition that all men are created equal.\n";
    //s2 = @"Yo";
    NSMutableAttributedString* content2 =
    [[NSMutableAttributedString alloc]
     initWithString:s2
     attributes:
     @{
     NSFontAttributeName:
     [UIFont fontWithName:@"HoeflerText-Black" size:16],
     NSKernAttributeName:[NSNull null] // required to get autokerning
     }];
    [content2 setAttributes:
     @{
        NSFontAttributeName:[UIFont fontWithName:@"HoeflerText-Black" size:24]
     } range:NSMakeRange(0,1)];
    [content2 addAttributes:
     @{
        NSKernAttributeName:@-4
     } range:NSMakeRange(0,1)];
    
    NSMutableParagraphStyle* para2 = [NSMutableParagraphStyle new];
    para2.headIndent = 10;
    para2.firstLineHeadIndent = 10;
    para2.tailIndent = -10;
    para2.lineBreakMode = NSLineBreakByWordWrapping;
    para2.alignment = NSTextAlignmentJustified;
    para2.lineHeightMultiple = 1.2;
    para2.hyphenationFactor = 1.0;
    [content2 addAttribute:NSParagraphStyleAttributeName
                     value:para2 range:NSMakeRange(0,1)];
    
    self.lab.attributedText = content2;
    NSLog(@"%f", self.lab2.preferredMaxLayoutWidth);
    self.lab2.preferredMaxLayoutWidth = 250;
    self.lab2.attributedText = content2;
    

}

-(void)viewDidLayoutSubviewsNOT { // there's a better way: see MyLabel.m
    self.lab.preferredMaxLayoutWidth = self.lab.bounds.size.width;
    [self.view layoutSubviews];
}

@end
