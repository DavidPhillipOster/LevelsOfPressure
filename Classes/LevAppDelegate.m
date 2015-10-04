//  Created by David Phillip Oster on 10/03/2015.
//  Apache Version 2 License

#import "LevAppDelegate.h"
#import "LevViewController.h"

@implementation LevAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  CGRect bounds = [[UIScreen mainScreen] bounds];
  [self setWindow:[[UIWindow alloc] initWithFrame:bounds]];
  [self setViewController:[[LevViewController alloc] init]];
  // Set the nav controller as the window's root view controller and display.
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_viewController];
  [_window setRootViewController:nav];
  [_window makeKeyAndVisible];
  return YES;
}

@end
