

#import "WebViewController.h"


@implementation WebViewController
@synthesize activity;

- (void)dealloc
{
    // deal with web view special needs
    [(UIWebView*)self.view stopLoading];
    [(UIWebView*)self.view setDelegate:nil];
    [activity release];
    [super dealloc];
}

- (void)loadView
{
    UIWebView* wv = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = wv;
    wv.delegate = self;
    
    UIActivityIndicatorView* act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activity = act;
    [wv addSubview:act];
    [act release];
    
    [wv release];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString* ss = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"htmlbody" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    
    NSError* err = nil;
    NSString* template = 
    [NSString stringWithContentsOfFile: 
     [[NSBundle mainBundle] pathForResource:@"htmlTemplate" ofType:@"txt"]
                              encoding: NSUTF8StringEncoding error:&err];
    // error-checking omitted
    NSString* s = [NSString stringWithFormat: template,
                   100,
                   18,
                   10,
                   @"http://tidbits.com/article/12228",
                   @"Lion Details Revealed with Shipping Date and Price", 
                   @"",
                   @"TidBITS Staff",
                   @"Mon, 06 Jun 2011 13:00:39 PDT",
                   ss
                   ];
    [(UIWebView*)self.view loadHTMLString:s baseURL:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    UIWebView* wv = (UIWebView*)self.view;
    NSString* scrolly = [wv stringByEvaluatingJavaScriptFromString: @"scrollY"];
    [[NSUserDefaults standardUserDefaults] setObject:scrolly forKey:@"scrolly"];
}

- (void)webViewDidStartLoad:(UIWebView *)wv {
    self.activity.center = 
    CGPointMake(CGRectGetMidX(wv.bounds), CGRectGetMidY(wv.bounds));
    [self.activity startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
    [self.activity stopAnimating];
    NSString* scrolly = [[NSUserDefaults standardUserDefaults] objectForKey:@"scrolly"];
    if (scrolly) {
        UIWebView* wv = (UIWebView*)self.view;
        [wv stringByEvaluatingJavaScriptFromString: 
         [NSString stringWithFormat: @"window.scrollTo(0, %@);", scrolly]];
    }
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    [self.activity stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)r 
 navigationType:(UIWebViewNavigationType)nt {
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
