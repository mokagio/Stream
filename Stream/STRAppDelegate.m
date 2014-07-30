#import "STRAppDelegate.h"

// Power logging
#import <DDTTYLogger.h>
#import <DDASLLogger.h>

@implementation STRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self setupDDLog];

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
