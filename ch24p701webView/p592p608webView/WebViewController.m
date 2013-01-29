

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate, UIViewControllerRestoration>
@property (nonatomic, strong) UIActivityIndicatorView* activity;
@property (nonatomic, strong) NSValue* oldOffset;
@end

@implementation WebViewController {
    BOOL _didDecode;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.restorationIdentifier = @"wvc";
        self.restorationClass = [self class];
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
    [coder encodeObject:
     [NSValue valueWithCGPoint:
      ((UIWebView*)self.view).scrollView.contentOffset]
                 forKey:@"oldOffset"];
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
    
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [wv.scrollView addGestureRecognizer:swipe];
    
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
    NSLog(@"swipe");
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"%@ %@", @"view did appear", ((UIWebView*)self.view).request);
    [super viewDidAppear:animated];
    
    UIWebView* wv = (id)self.view;
    
    // uncomment this section to experiment with state saving and restoration
    /*
    
    if (self->_didDecode) {
        self->_didDecode = NO;
        if (wv.request)
            [wv loadRequest:wv.request];
        NSLog(@"%@", @"I'm outta here");
        return;
    }
     NSURL* url = [NSURL URLWithString:@"http://www.apeth.com/RubyFrontierDocs/default.html"];
    [wv loadRequest:[NSURLRequest requestWithURL:url]];
    return;
     
     */
    
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
    if (self.oldOffset) {
        wv.scrollView.contentOffset = [self.oldOffset CGPointValue];
        self.oldOffset = nil;
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
        NSLog(@"user would like to navigate to %@", r.URL);
        // [[UIApplication sharedApplication] openURL:r.URL];
        return NO;
    }
    return YES;
}


@end
