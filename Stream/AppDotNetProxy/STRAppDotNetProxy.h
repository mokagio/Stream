#import <Foundation/Foundation.h>

typedef void (^STRAppDotNetProxySuccessBlock)(NSArray *posts);
typedef void (^STRAppDotNetProxyFailureBlock)(NSError *error);

@interface STRAppDotNetProxy : NSObject

/**
 *  Returns an instance proprely configured to interact with the server.
 *  Please use this method to instanciate STRAppDotNetProxy
 *
 *  @return an instance properly configured
 */
+ (instancetype)configuredProxy;

- (void)getPostsWithSuccessBlock:(STRAppDotNetProxySuccessBlock)successBlock
                    failureBlock:(STRAppDotNetProxyFailureBlock)failureBlock;

@end

///----------------
/// @name Constants
///----------------

extern NSString * const STRAppDotNetBaseURL;
extern NSString * const STRAppDotNetPostsEndPoint;
