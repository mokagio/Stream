#import "STRNavigationController.h"
#import <UIColor+FlatColors.h>
#import <UIFont+OpenSans.h>

@implementation STRNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (!self) { return nil; }

    self.navigationBar.barTintColor = [UIColor flatWisteriaColor];
    self.navigationBar.titleTextAttributes = @{
                                               NSFontAttributeName: [UIFont openSansBoldFontOfSize:[UIFont labelFontSize]],
                                               NSForegroundColorAttributeName: [UIColor whiteColor],
                                               };
    self.navigationBar.tintColor = [UIColor whiteColor];

    return self;
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
