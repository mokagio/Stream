#import "STRNetworkManager.h"

@interface STRNetworkManager ()

@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation STRNetworkManager

- (id)initWithBaseURL:(NSURL *)url
{
    NSParameterAssert(url);

    self = [super init];
    if (!self) { return nil; }

    self.baseURL = url;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configuration];

    return self;
}

- (id)init
{
    return [self initWithBaseURL:nil];
}

- (void)runGETRequestToEndPoint:(NSString *)endPoint
                 withParameters:(NSDictionary *)parameters
                   successBlock:(STRNetworkSuccessResponseBlock)successBlock
                   failureBlock:(STRNetworkFailureResponseBlock)failureBlock
{
    __block NSURL *url = [self.baseURL URLByAppendingPathComponent:endPoint];
    __block NSUInteger i = 0;
    // TODO: we are assuming all the parameters are in NSString format here
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString *value, BOOL *stop) {
        NSString *prefix = i == 0 ? @"?" : @"&";
        NSString *parameter = [NSString stringWithFormat:@"%@%@=%@", prefix, key, value];

        url = [url URLByAppendingPathComponent:parameter];

        i++;
    }];
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                         if (error) {
                                                             failureBlock(error);
                                                             return;
                                                         }

                                                         NSError *serializationError = nil;
                                                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                              options:kNilOptions
                                                                                                                error:&serializationError];

                                                         if (serializationError) {
                                                             failureBlock(serializationError);
                                                             return;
                                                         }

                                                         successBlock(json);
                                                 }];
    [dataTask resume];
}

- (void)runDownloadRequestToURL:(NSURL *)url
                   successBlock:(STRNetworkDownloadSuccessResponseBlock)successBlock
                   failureBlock:(STRNetworkFailureResponseBlock)failureBlock
{
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            failureBlock(error);
            return;
        }

        NSData *data = [NSData dataWithContentsOfURL:location];
        successBlock(data);
    }];

    [downloadTask resume];
}

@end
