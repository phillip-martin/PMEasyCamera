#import "PMDemoAppDelegate.h"
#import "PMDemoViewController.h"

@interface PMDemoAppDelegate ()

@end

@implementation PMDemoAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    PMDemoViewController *mainViewController = [[PMDemoViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:mainViewController];
    [self.window setRootViewController:navigationController];
    return YES;
}

@end

