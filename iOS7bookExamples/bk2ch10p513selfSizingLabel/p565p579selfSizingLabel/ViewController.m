

#import "ViewController.h"

@implementation ViewController {
    IBOutlet __weak UILabel *theLabel;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    /*
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.headIndent = 20;
    para.firstLineHeadIndent = 20;
    para.tailIndent = -20;
    NSMutableAttributedString* att = [[self->theLabel attributedText] mutableCopy];
    [att addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0,1)];
    [self->theLabel setAttributedText:att];
     */
    
    [self->theLabel sizeToFit];
}


@end
