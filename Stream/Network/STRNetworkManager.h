#import <Foundation/Foundation.h>

typedef void (^STRNeworkSuccessResponseBlock)(NSDictionary *responseDict);
typedef void (^STRNetworkFailureResponseBlock)(NSError *error);

@interface STRNetworkManager : NSObject

/**
 *  This is the designated initializer
 */
- (id)initWithBaseURL:(NSURL *)url;

- (void)runGETRequestToEndPoint:(NSString *)endPoint
                 withParameters:(NSDictionary *)parameters
                   successBlock:(STRNeworkSuccessResponseBlock)successBlock
                   failureBlock:(STRNetworkFailureResponseBlock)failureBlock;

@end
