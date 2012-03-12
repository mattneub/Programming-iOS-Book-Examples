
#import "MyCell.h"

@implementation MyCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    return; // comment out this line to see my experiment with detecting menu-showing state
    
    // walk up responder chain looking for menu state
    if (selected) {
        UIResponder* r = self;
        while (![r respondsToSelector:@selector(aboutToShowMenu)])
            r = [r nextResponder];        
        if (r && (BOOL)[r performSelector:@selector(aboutToShowMenu)]) {
            self.selectionStyle = UITableViewCellSelectionStyleGray;
        } else {
            self.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
    }

}

@end
