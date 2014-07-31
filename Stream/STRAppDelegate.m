#import "STRAppDelegate.h"

// View Controller
#import "STRPostsViewController.h"
#import "STRNavigationController.h"

// Managers & Co.
#import "STRAppDotNetProxy.h"

// Power logging
#import <DDTTYLogger.h>
#import <DDASLLogger.h>

@implementation STRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self setupDDLog];

    STRAppDotNetProxy *appDotNetProxy = [STRAppDotNetProxy configuredProxy];
    STRPostsViewController *postsViewController = [[STRPostsViewController alloc] initWithAppDotNetProxy:appDotNetProxy];
    STRNavigationController *navigationController = [[STRNavigationController alloc] initWithRootViewController:postsViewController];

    self.window.rootViewController = navigationController;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - CocoaLumberjack Logging

- (void)setupDDLog
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    DDTTYLogger *ttyLogger = [DDTTYLogger sharedInstance];
    [ttyLogger setColorsEnabled:YES];
    [ttyLogger setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:LOG_FLAG_ERROR];
    [ttyLogger setForegroundColor:[UIColor orangeColor] backgroundColor:nil forFlag:LOG_FLAG_WARN];
    [ttyLogger setForegroundColor:[UIColor yellowColor] backgroundColor:nil forFlag:LOG_FLAG_DEBUG];
    [ttyLogger setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
    [ttyLogger setForegroundColor:[UIColor cyanColor] backgroundColor:nil forFlag:LOG_FLAG_VERBOSE];
}

@end
