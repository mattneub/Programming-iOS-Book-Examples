

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate, UIViewControllerRestoration>
@property (nonatomic, strong) UIActivityIndicatorView* activity;
@property (nonatomic, strong) NSValue* oldOffset;
@end

@implementation WebViewController {
    BOOL _didDecode;
    BOOL _canNavigate;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.restorationIdentifier = @"wvc";
        self.restorationClass = [self class];
        UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        self.navigationItem.rightBarButtonItem = b;
    }
    return self;
}

+(UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    return [[self class] new];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@", @"decode");
    [super decodeRestorableStateWithCoder:coder];
    self.oldOffset = [coder decodeObjectForKey:@"oldOffset"];
    self->_didDecode = YES;
}

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@", @"encode");
    [super encodeRestorableStateWithCoder:coder];
    // for our *local* page example, save offset for manual restore
    if (!self->_canNavigate) {
        NSLog(@"%@", @"saving offset");
        [coder encodeObject:
         [NSValue valueWithCGPoint:
          ((UIWebView*)self.view).scrollView.contentOffset]
                     forKey:@"oldOffset"];
    }
}

- (void)dealloc
{
    // deal with web view special needs
    NSLog(@"%@", @"dealloc");
    [(UIWebView*)self.view stopLoading];
    [(UIWebView*)self.view setDelegate:nil];
}

- (void)loadView
{
    UIWebView* wv = [UIWebView new];
    wv.restorationIdentifier = @"wv";
    wv.backgroundColor = [UIColor blackColor];
    self.view = wv;
    wv.delegate = self;
    
    // prove that we can attach gesture recognizer to web view's scroll view
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [wv.scrollView addGestureRecognizer:swipe];
    
    // prepare nice activity indicator to cover loading
    UIActivityIndicatorView* act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    act.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    self.activity = act;
    [wv addSubview:act];
    act.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:act attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:wv attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:act attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:wv attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    // NSLog(@"%@", wv.scrollView.gestureRecognizers);
}

- (void) swipe: (id) dummy {
    NSLog(@"swipe"); // okay, you proved it :)
}

#define LOADREQ 1 // 0, or try 1 for a different application...
// one that loads an actual request and lets you experiment with state saving and restoration

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIWebView* wv = (id)self.view;
    NSLog(@"%@ req: %@ can go back: %i", @"view did appear", wv.request, wv.canGoBack);

    
#if LOADREQ == 1
    
    self ->_canNavigate = YES;
    if (self->_didDecode) {
        if (wv.request)
            [wv loadRequest:wv.request];
        NSLog(@"%@", @"I'm outta here");
        return;
    }
    NSURL* url = [NSURL URLWithString:@"http://www.apeth.com/RubyFrontierDocs/default.html"];
    [wv loadRequest:[NSURLRequest requestWithURL:url]];
    return;

#endif
     
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"htmlbody" ofType:@"txt"];
    NSURL* base = [NSURL fileURLWithPath:path];
    NSString* ss = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSError* err = nil;
    NSString* template = 
    [NSString stringWithContentsOfFile: 
     [[NSBundle mainBundle] pathForResource:@"htmlTemplate" ofType:@"txt"]
                              encoding: NSUTF8StringEncoding error:&err];
    // error-checking omitted
    NSString* s = template;
    s = [s stringByReplacingOccurrencesOfString:@"<maximagewidth>" withString:@"80%"];
    s = [s stringByReplacingOccurrencesOfString:@"<fontsize>" withString:@"18"];
    s = [s stringByReplacingOccurrencesOfString:@"<margin>" withString:@"10"];
    s = [s stringByReplacingOccurrencesOfString:@"<guid>" withString:@"http://tidbits.com/article/12228"];
    s = [s stringByReplacingOccurrencesOfString:@"<ourtitle>" withString:@"Lion Details Revealed with Shipping Date and Price"];
    s = [s stringByReplacingOccurrencesOfString:@"<playbutton>" withString:@"<img src=\"listen.png\" onclick=\"document.location='play:me'\">"];
    s = [s stringByReplacingOccurrencesOfString:@"<author>" withString:@"TidBITS Staff"];
    s = [s stringByReplacingOccurrencesOfString:@"<date>" withString:@"Mon, 06 Jun 2011 13:00:39 PDT"];
    s = [s stringByReplacingOccurrencesOfString:@"<content>" withString:ss];

    [wv loadHTMLString:s baseURL:base];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)webViewDidStartLoad:(UIWebView *)wv {
    NSLog(@"%@", @"start load");
    [self.activity startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
    [self.activity stopAnimating];
    // for our *local* example, restoring offset is up to us
    if (self.oldOffset) {
        NSLog(@"%@", @"restoring offset");
        wv.scrollView.contentOffset = [self.oldOffset CGPointValue];
    } else if (self->_didDecode && wv.canGoBack) {
        NSLog(@"%@", @"going back, going back, going back to Nassau Hall");
        [wv goBack];
    }
    self.oldOffset = nil;
    self->_didDecode = NO;
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
        if (self->_canNavigate)
            return YES;
        NSLog(@"user would like to navigate to %@", r.URL);
        // this is how you would open in Mobile Safari
        // [[UIApplication sharedApplication] openURL:r.URL];
        return NO;
    }
    return YES;
}

- (void) goBack: (id) sender {
    UIWebView* wv = (id)self.view;
    if (wv.canGoBack)
        [wv goBack];
}


@end
