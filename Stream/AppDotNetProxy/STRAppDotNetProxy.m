#import "STRAppDotNetProxy.h"

// Components
#import "STRNetworkManager.h"
#import "STRParser.h"

#import "STRPost.h"

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

#pragma mark - Get Posts

- (void)getPostsWithSuccessBlock:(STRAppDotNetProxySuccessBlock)successBlock
                    failureBlock:(STRAppDotNetProxyFailureBlock)failureBlock
{
    [self getPostsWithParameters:nil successBlock:successBlock failureBlock:failureBlock];
}

- (void)getPostsAfterPost:(STRPost *)post
         withSuccessBlock:(STRAppDotNetProxySuccessBlock)successBlock
             failureBlock:(STRAppDotNetProxyFailureBlock)failureBlock
{
    NSDictionary *parameters = @{ @"before_id": post.uid };
    [self getPostsWithParameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

- (void)getPostsWithParameters:(NSDictionary *)parameters
                  successBlock:(STRAppDotNetProxySuccessBlock)successBlock
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
                                  withParameters:parameters
                                    successBlock:success
                                    failureBlock:failure];
}

@end
