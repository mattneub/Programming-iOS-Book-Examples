
#import "RootViewController.h"

@implementation RootViewController

@synthesize nsb, services;

- (void)dealloc
{
    [nsb release];
    [services release];
    [super dealloc];
}

// tap button, watch console when you turn on Sharing in iTunes

- (IBAction)doButton:(id)sender {
    self.services = [NSMutableArray array];
    NSNetServiceBrowser* browser = [[NSNetServiceBrowser alloc] init];
    self.nsb = browser;
    [browser release];
    self.nsb.delegate = self;
    [self.nsb searchForServicesOfType:@"_daap._tcp" inDomain:@""];
}

- (void) updateInterface {
    for (NSNetService* service in self.services) {
        if (service.port == -1) {
            NSLog(@"service %@ of type %@, not yet resolved", 
                  service.name, service.type);
            [service setDelegate:self];
            [service resolveWithTimeout:10];
        } else {
            NSLog(@"service %@ of type %@, port %i, addresses %@", 
                  service.name, service.type, service.port, service.addresses);
        }
    }
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    [self updateInterface];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser 
           didFindService:(NSNetService *)netService 
               moreComing:(BOOL)moreServicesComing {
    [self.services addObject:netService];
    NSLog(@"adding a service");
    if (!moreServicesComing)
        [self updateInterface];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser 
         didRemoveService:(NSNetService *)netService 
               moreComing:(BOOL)moreServicesComing {
    [self.services removeObject:netService];
    NSLog(@"removing a service");
    if (!moreServicesComing)
        [self updateInterface];
}




@end
