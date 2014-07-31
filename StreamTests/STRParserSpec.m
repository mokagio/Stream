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

        it(@"should return nil if the id is missing", ^{
            STRPost *post = [parser parsePostFromDictionary:@{ @"not_the_id": @"any string" }];
            expect(post).to.beNil();
        });

        it(@"should return nil if the text is missing", ^{
            STRPost *post = [parser parsePostFromDictionary:@{ @"id": @"any_id", @"not_the_text": @"any string" }];
            expect(post).to.beNil();
        });

        it(@"should return nil if the user is missing", ^{
            STRPost *post = [parser parsePostFromDictionary:@{ @"id": @"any_id", @"text": @"any string" }];
            expect(post).to.beNil();
        });
    });

    context(@"when parsing a post from a valid dictionary", ^{
        __block STRPost *post;
        __block NSDictionary *postDictionary;

        beforeAll(^{
            postDictionary = validPostsDictionary[@"data"][0];
            post = [parser parsePostFromDictionary:postDictionary];
        });

        it(@"should set the right id", ^{
            expect(post.uid).to.equal(postDictionary[@"id"]);
        });

        it(@"should set the right text", ^{
            expect(post.text).to.equal(postDictionary[@"text"]);
        });

        it(@"should set the right user name", ^{
            expect(post.authorName).to.equal(postDictionary[@"user"][@"name"]);
        });

        it(@"should set the right user handle", ^{
            expect(post.authorHandle).to.equal(postDictionary[@"user"][@"username"]);
        });

        it(@"should set the right user avatar URL", ^{
            NSURL *url = [NSURL URLWithString:postDictionary[@"user"][@"avatar_image"][@"url"]];
            expect(post.authorAvatarURL).to.equal(url);
        });

        it(@"should set the right post created date", ^{
            NSDateFormatter *f = [[NSDateFormatter alloc] init];
            f.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
            NSDate *date = [f dateFromString:postDictionary[@"created_at"]];
            expect(post.createdDate).to.equal(date);
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
