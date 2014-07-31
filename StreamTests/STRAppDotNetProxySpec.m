#import "STRAppDotNetProxy.h"

SpecBegin(STRAppDotNetProxy)

describe(@"STRAppDotNetProxy", ^{
    it(@"should know the App.net API url", ^{
        expect(STRAppDotNetBaseURL).to.equal(@"https://api.app.net");
    });

    it(@"should know the posts endpoint path", ^{
        expect(STRAppDotNetPostsEndPoint).to.equal(@"posts/stream/global");
    });
});

SpecEnd
