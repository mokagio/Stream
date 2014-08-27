#import <Foundation/Foundation.h>

typedef void (^STRNetworkSuccessResponseBlock)(NSDictionary *responseDict);
typedef void (^STRNetworkDownloadSuccessResponseBlock)(NSData *responseData);
typedef void (^STRNetworkFailureResponseBlock)(NSError *error);

@interface STRNetworkManager : NSObject

/**
 *  This is the designated initializer
 */
- (id)initWithBaseURL:(NSURL *)url;

- (void)runGETRequestToEndPoint:(NSString *)endPoint
                 withParameters:(NSDictionary *)parameters
                   successBlock:(STRNetworkSuccessResponseBlock)successBlock
                   failureBlock:(STRNetworkFailureResponseBlock)failureBlock;

- (void)runDownloadRequestToURL:(NSURL *)url
                   successBlock:(STRNetworkDownloadSuccessResponseBlock)successBlock
                   failureBlock:(STRNetworkFailureResponseBlock)failureBlock;

@end
