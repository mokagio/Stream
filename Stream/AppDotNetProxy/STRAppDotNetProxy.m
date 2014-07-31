#import "STRAppDotNetProxy.h"

// Components
#import "STRNetworkManager.h"
#import "STRParser.h"

NSString * const STRAppDotNetBaseURL = @"https://api.app.net";
NSString * const STRAppDotNetPostsEndPoint = @"posts/stream/global";

@interface STRAppDotNetProxy ()

@property (nonatomic, strong) STRNetworkManager *networkManager;
@property (nonatomic, strong) STRParser *parser;

@end

@implementation STRAppDotNetProxy

+ (instancetype)configuredProxy
{
    STRAppDotNetProxy *proxy = [[STRAppDotNetProxy alloc] init];

    NSURL *url = [NSURL URLWithString:STRAppDotNetBaseURL];
    proxy.networkManager = [[STRNetworkManager alloc] initWithBaseURL:url];

    proxy.parser = [[STRParser alloc] init];

    return proxy;
}

@end
