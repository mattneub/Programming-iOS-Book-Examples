

#import "ViewController.h"
@import ObjectiveC;

@interface ViewController ()
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSNumber* number;
@end

@implementation ViewController  {
    NSString* _name; // since we're going to use @dynamic, we need to declare any ivars manually
    NSNumber* _number;
}
@dynamic name, number;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.name = @"Fido";
    NSLog(@"%@", self.name);
    self.number = @42;
    NSLog(@"%@", self.number);
    // that compiles; @dynamic means the compiler is trusting us
    // but it also means that we don't synthesize accessors
    // so accessors need to come from somewhere, or we'll crash at runtime trying to call setName:
}

+ (BOOL) resolveInstanceMethod: (SEL) sel {
    // dynamic method creation! the first time setName: or name or setNumber: or number is called...
    // this method will be called
    if (sel == @selector(setName:) || sel == @selector(setNumber:)) {
        class_addMethod([self class], sel, (IMP) callSetValueForKey, "v@:@");
        return YES;
    }
    if (sel == @selector(name) || sel == @selector(number)) {
        class_addMethod([self class], sel, (IMP) callValueForKey, "@@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

// because we've cleverly used ivars whose names start with underscore,
// there is no infinite recursion in using key-value coding to access those ivars by name

void callSetValueForKey(id self, SEL _cmd, id value) {
    NSString* key = NSStringFromSelector(_cmd);
    key = [key substringWithRange:NSMakeRange(3, [key length]-4)];
    NSString* firstCharLower = [[key substringWithRange:NSMakeRange(0,1)] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCharLower];
    key = [@"_" stringByAppendingString:key];
    [self setValue:value forKey:key];
}

id callValueForKey(id self, SEL _cmd) {
    NSString* key = NSStringFromSelector(_cmd);
    key = [@"_" stringByAppendingString:key];
    return [self valueForKey:key];
}


@end
