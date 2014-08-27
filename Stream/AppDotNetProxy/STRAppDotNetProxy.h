#import <UIKit/UIKit.h>

typedef void (^STRAppDotNetProxySuccessBlock)(NSArray *posts);
typedef void (^STRAppDotNetProxyFailureBlock)(NSError *error);
typedef void (^STRAppDotNetProxyImageSuccessBlock)(UIImage *image);

@class STRPost;

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

- (void)getPostsAfterPost:(STRPost *)post
         withSuccessBlock:(STRAppDotNetProxySuccessBlock)successBlock
             failureBlock:(STRAppDotNetProxyFailureBlock)failureBlock;

- (void)getPostsWithParameters:(NSDictionary *)parameters
                  successBlock:(STRAppDotNetProxySuccessBlock)successBlock
                  failureBlock:(STRAppDotNetProxyFailureBlock)failureBlock;

- (void)getAvatarImageForPost:(STRPost *)post
             withSuccessBlock:(STRAppDotNetProxyImageSuccessBlock)successBlock
                 failureBlock:(STRAppDotNetProxyFailureBlock)failureBlock;

@end

///----------------
/// @name Constants
///----------------

extern NSString * const STRAppDotNetBaseURL;
extern NSString * const STRAppDotNetPostsEndPoint;
