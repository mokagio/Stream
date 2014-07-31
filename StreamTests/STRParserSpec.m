#import "STRParser.h"
#import "STRPost.h"

SpecBegin(STRParser)

describe(@"STRParser", ^{
    __block STRParser *parser;
    __block NSDictionary *validPostsDictionary;

    beforeAll(^{
        parser = [[STRParser alloc] init];

        NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"posts_success" ofType:@"json"];
        validPostsDictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:kNilOptions error:nil];
    });

    context(@"when parsing a post from an invalid dictionary", ^{
        it(@"should return nil if the dictionary is missing", ^{
            STRPost *post = [parser parsePostFromDictionary:nil];
            expect(post).to.beNil();
        });

        it(@"should return nil if the text is missing", ^{
            STRPost *post = [parser parsePostFromDictionary:@{ @"not_the_text": @"any string" }];
            expect(post).to.beNil();
        });
    });

    context(@"when parsing a post from a valid dictionary", ^{
        it(@"should set the right text", ^{
            NSDictionary *postDictionary = validPostsDictionary[@"data"][0];
            STRPost *post = [parser parsePostFromDictionary:postDictionary];

            expect(post.text).to.equal(postDictionary[@"text"]);
        });
    });

    context(@"when parsing an array of posts from an invalid dictionary", ^{
        it(@"should return nil if the dictionary is missing", ^{
            NSArray *posts = [parser parsePostsFromDictionary:nil];
            expect(posts).to.beNil();
        });

        it(@"should return nil if the posts are missing", ^{
            NSArray *posts = [parser parsePostsFromDictionary:@{ @"not_the_posts_key" : @[ @"margherita", @"quattro formaggi" ] }];
            expect(posts).to.beNil();
        });
    });

    context(@"when parsing an array of posts form a valid dictionary", ^{
        __block NSArray *posts;

        beforeAll(^{
            posts = [parser parsePostsFromDictionary:validPostsDictionary];
        });

        it(@"should return the expected number of objects", ^{
            NSUInteger expectedCount = [validPostsDictionary[@"data"] count];
            expect([posts count]).to.equal(expectedCount);
        });

        it(@"should return instances of STRPosts", ^{
            [posts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                expect(obj).to.beKindOf([STRPost class]);
            }];
        });
    });
});

SpecEnd
