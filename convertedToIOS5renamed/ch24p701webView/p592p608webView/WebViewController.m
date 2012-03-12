

#import "WebViewController.h"

@interface WebViewController ()
@property (nonatomic, strong) UIActivityIndicatorView* activity;
@end

@implementation WebViewController
@synthesize activity;

- (void)dealloc
{
    // deal with web view special needs
    [(UIWebView*)self.view stopLoading];
    [(UIWebView*)self.view setDelegate:nil];
}

- (void)loadView
{
    UIWebView* wv = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    wv.backgroundColor = [UIColor blackColor];
    self.view = wv;
    wv.delegate = self;
    
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [wv.scrollView addGestureRecognizer:swipe];
    
    UIActivityIndicatorView* act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    act.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    self.activity = act;
    [wv addSubview:act];
    
    NSLog(@"%@", wv.scrollView.gestureRecognizers);
}

- (void) swipe: (id) dummy {
    NSLog(@"swipe");
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"htmlbody" ofType:@"txt"];
    NSURL* base = [NSURL fileURLWithPath:path];
    NSString* ss = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSError* err = nil;
    NSString* template = 
    [NSString stringWithContentsOfFile: 
     [[NSBundle mainBundle] pathForResource:@"htmlTemplate" ofType:@"txt"]
                              encoding: NSUTF8StringEncoding error:&err];
    // error-checking omitted
    NSString* s = [NSString stringWithFormat: template,
                   300, // -> what was I thinking???? fixed now
                   18,
                   10,
                   @"http://tidbits.com/article/12228",
                   @"Lion Details Revealed with Shipping Date and Price", 
                   @"<img src=\"listen.png\" onclick=\"document.location='play:me'\">",
                   @"TidBITS Staff",
                   @"Mon, 06 Jun 2011 13:00:39 PDT",
                   ss
                   ];
    [(UIWebView*)self.view loadHTMLString:s baseURL:base];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    UIWebView* wv = (UIWebView*)self.view;
    // old
    /*
    NSString* scrolly = [wv stringByEvaluatingJavaScriptFromString: @"scrollY"];
    [[NSUserDefaults standardUserDefaults] setObject:scrolly forKey:@"scrolly"];
     */
    // new
    NSValue* val = [NSValue valueWithCGPoint:wv.scrollView.contentOffset];
    NSData* dat = [NSKeyedArchiver archivedDataWithRootObject:val];
    [[NSUserDefaults standardUserDefaults] setObject:dat forKey:@"scrollnew"];
}

- (void)webViewDidStartLoad:(UIWebView *)wv {
    self.activity.center = 
    CGPointMake(CGRectGetMidX(wv.bounds), CGRectGetMidY(wv.bounds));
    [self.activity startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
    [self.activity stopAnimating];
    // old
    /*
    NSString* scrolly = [[NSUserDefaults standardUserDefaults] objectForKey:@"scrolly"];
    if (scrolly) {
        UIWebView* wv = (UIWebView*)self.view;
        [wv stringByEvaluatingJavaScriptFromString: 
         [NSString stringWithFormat: @"window.scrollTo(0, %@);", scrolly]];
    }
     */
    // new
    NSData* dat = [[NSUserDefaults standardUserDefaults] objectForKey:@"scrollnew"];
    if (dat) {
        NSValue* val = [NSKeyedUnarchiver unarchiveObjectWithData:dat];
        UIWebView* wv = (UIWebView*)self.view;
        wv.scrollView.contentOffset = [val CGPointValue];
    }
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    [self.activity stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)r 
 navigationType:(UIWebViewNavigationType)nt {
    if ([r.URL.scheme isEqualToString: @"play"]) {
        NSLog(@"user would like to hear the podcast");
        return NO;
    }
    if (nt == UIWebViewNavigationTypeLinkClicked) { // disable link-clicking
        // [[UIApplication sharedApplication] openURL:r.URL];
        return NO;
    }
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
