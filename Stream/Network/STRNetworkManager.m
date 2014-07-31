#import "STRNetworkManager.h"
#import <AFNetworking.h>

@interface STRNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation STRNetworkManager

- (id)initWithBaseURL:(NSURL *)url
{
    NSParameterAssert(url);

    self = [super init];
    if (!self) { return nil; }

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url
                                                   sessionConfiguration:configuration];
    self.sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];

    return self;
}

- (id)init
{
    return [self initWithBaseURL:nil];
}

- (void)runGETRequestToEndPoint:(NSString *)endPoint
                 withParameters:(NSDictionary *)parameters
                   successBlock:(STRNeworkSuccessResponseBlock)successBlock
                   failureBlock:(STRNetworkFailureResponseBlock)failureBlock
{
    void (^success)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject){
        successBlock(responseObject);
    };

    void (^failure)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error){
        failureBlock(error);
    };

    [self.sessionManager GET:endPoint
                  parameters:parameters
                     success:success
                     failure:failure];
}

@end
