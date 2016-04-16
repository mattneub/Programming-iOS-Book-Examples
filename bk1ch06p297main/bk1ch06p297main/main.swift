
import UIKit

// Objective-C:

// UIKIT_EXTERN int UIApplicationMain(
//   int argc,
//   char *argv[],
//   NSString * __nullable principalClassName,
//   NSString * __nullable delegateClassName);

// Swift:

// public func UIApplicationMain(
//    _ argc: Int32,
//    _ argv: UnsafeMutablePointer<UnsafeMutablePointer<Int8>>!,
//    _ principalClassName: String?,
//    _ delegateClassName: String?) -> Int32

// but Process.unsafeArgv is:

// static var unsafeArgv: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?> { get }

// thus there is a mismatch in the type of argv; this will no longer compile:

//UIApplicationMain(
//    Process.argc, Process.unsafeArgv, nil, NSStringFromClass(AppDelegate)
//)


// Jordan Rose at Apple says to use this:

UIApplicationMain(
    Process.argc, UnsafeMutablePointer<UnsafeMutablePointer<CChar>>(Process.unsafeArgv), nil, NSStringFromClass(AppDelegate)
)

