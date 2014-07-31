#import <Foundation/Foundation.h>

@interface STRAppDotNetProxy : NSObject

/**
 *  Returns an instance proprely configured to interact with the server.
 *  Please use this method to instanciate STRAppDotNetProxy
 *
 *  @return an instance properly configured
 */
+ (instancetype)configuredProxy;

@end

///----------------
/// @name Constants
///----------------

extern NSString * const STRAppDotNetBaseURL;
extern NSString * const STRAppDotNetPostsEndPoint;
