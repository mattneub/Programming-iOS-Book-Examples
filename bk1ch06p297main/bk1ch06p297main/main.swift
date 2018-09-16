
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

// This compiles and runs, but heaven knows if it's right

//UIApplicationMain(
//    CommandLine.argc,
//    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
//        .bindMemory(
//            to: UnsafeMutablePointer<Int8>?.self,
//            capacity: Int(CommandLine.argc)),
//    nil,
//    NSStringFromClass(AppDelegate.self)
//)

// Oooooh, this seems to be fixed (using CommandLine instead of Process):

UIApplicationMain(
    CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self)
)


