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

- (void)getPostsWithSuccessBlock:(STRAppDotNetProxySuccessBlock)successBlock
                    failureBlock:(STRAppDotNetProxyFailureBlock)failureBlock
{
    NSParameterAssert(successBlock);
    NSParameterAssert(failureBlock);
    
    STRNetworkSuccessResponseBlock success = ^(NSDictionary *dictionary) {
        NSArray *posts = [self.parser parsePostsFromDictionary:dictionary];
        successBlock(posts);
    };

    STRNetworkFailureResponseBlock failure = ^(NSError *error) {
        DDLogError(@"Get posts request failed with error: %@", error);

        failureBlock(error);
    };

    [self.networkManager runGETRequestToEndPoint:STRAppDotNetPostsEndPoint
                                  withParameters:nil
                                    successBlock:success
                                    failureBlock:failure];
}

@end
