#import "STRAppDotNetProxy.h"
#import "STRPost.h"
#import <OHHTTPStubs.h>

SpecBegin(STRAppDotNetProxy)

describe(@"STRAppDotNetProxy", ^{
    __block STRAppDotNetProxy *proxy;

    beforeAll(^{
        proxy = [STRAppDotNetProxy configuredProxy];
    });

    afterEach(^{
        [OHHTTPStubs removeAllStubs];
    });

    it(@"should know the App.net API url", ^{
        expect(STRAppDotNetBaseURL).to.equal(@"https://api.app.net");
    });

    it(@"should know the posts endpoint path", ^{
        expect(STRAppDotNetPostsEndPoint).to.equal(@"posts/stream/global");
    });

    context(@"when getting posts from the server", ^{
        context(@"when the request is successful", ^{
            it(@"should return an array of STRPost instances", ^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.URL.host isEqualToString:@"api.app.net"];
                } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"posts_success.json", nil)
                                                            statusCode:200
                                                               headers:@{@"Content-Type":@"text/json"}];
                }];

                __block NSArray *posts = nil;
                NSDictionary *parameters = @{ @"any_key": @"any_value" };
                [proxy getPostsWithParameters:parameters
                                 successBlock:^(NSArray *_posts) {
                                     posts = _posts;
                                 } failureBlock:^(NSError *error) {
                                     // do nothing
                                 }];

                expect(posts).willNot.beNil();
                [posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    expect(obj).will.beKindOf([STRPost class]);
                }];
            });
        });

        context(@"when the request fails", ^{
            it(@"should run the failure block", ^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.URL.host isEqualToString:@"api.app.net"];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"posts_404.json", nil)
                                                            statusCode:404
                                                               headers:@{ @"Content-Type": @"text/json" }];
                }];

                __block NSError *error = nil;
                NSDictionary *parameters = @{ @"any_key": @"any_value" };
                [proxy getPostsWithParameters:parameters
                                 successBlock:^(NSArray *posts) {
                                     // do nothing
                                 } failureBlock:^(NSError *e) {
                                     error = e;
                                 }];
                // Calling e _error causes a shadow variable warning.
                // That's funny because that's not happening with posts and _posts in the spec above
                // o.O

                expect(error).willNot.beNil();
            });
        });
    });

    context(@"when getting the avatar image for a post", ^{
        __block UIImage *image = nil;

        context(@"when the request is successful", ^{
            beforeAll(^{
                __block STRPost *post;
                __block NSString *anyImageURLString = @"http://www.dummy.com/avatar.png";

                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.URL.absoluteString isEqualToString:anyImageURLString];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"michelangelo.png", nil)
                                                            statusCode:200
                                                               headers:@{ @"Content-Type": @"image/png" }];
                }];

                post = [[STRPost alloc] init];
                post.authorAvatarURL = [NSURL URLWithString:anyImageURLString];

                [proxy getAvatarImageForPost:post
                            withSuccessBlock:^(UIImage *_image) {
                                image = _image;
                            } failureBlock:^(NSError *error) {
                                // do nothing
                            }];
            });

            it(@"should call the success callback", ^{
                expect(image).willNot.beNil();
            });

            it(@"should pass a valid image to the success callback", ^{
                expect(image).will.beKindOf([UIImage class]);
            });
        });

        context(@"when the request fails", ^{
            __block NSError *error = nil;

            beforeAll(^{
                __block STRPost *post;
                __block NSString *anyImageURLString = @"http://www.dummy.com/avatar.png";

                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.URL.absoluteString isEqualToString:anyImageURLString];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"posts_404.json", nil)
                                                            statusCode:404
                                                               headers:@{ @"Content-Type": @"text/json" }];
                }];

                post = [[STRPost alloc] init];
                post.authorAvatarURL = [NSURL URLWithString:anyImageURLString];

                [proxy getAvatarImageForPost:post
                            withSuccessBlock:^(UIImage *image) {
                                // do nothing
                            } failureBlock:^(NSError *e) {
                                error = e;
                            }];
            });


            it(@"should call the failure callback", ^{
                expect(error).will.beNil();
            });
        });
    });
});

SpecEnd
