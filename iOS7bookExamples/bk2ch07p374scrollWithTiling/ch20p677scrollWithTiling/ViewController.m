

#import "ViewController.h"
#import "TiledView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (strong, nonatomic) TiledView* content;
@end

@implementation ViewController

-(void)viewDidLoad {
    CGRect f = CGRectMake(0,0,3*TILESIZE,3*TILESIZE);
    TiledView* content = [[TiledView alloc] initWithFrame:f];
    float tsz = TILESIZE * content.layer.contentsScale;
    [(CATiledLayer*)content.layer setTileSize: CGSizeMake(tsz, tsz)];
    [self.sv addSubview:content];
    [self.sv setContentSize: f.size];
    self.content = content;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
