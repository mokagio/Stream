#import "STRParser.h"
#import "STRPost.h"

SpecBegin(STRParser)

describe(@"STRParser", ^{
    __block STRParser *parser;

    beforeAll(^{
        parser = [[STRParser alloc] init];
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

    context(@"when parsing a post from a dictionary", ^{
        it(@"should set the right text", ^{
            NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"posts_success" ofType:@"json"];
            NSDictionary *postsDictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:kNilOptions error:nil];
            NSDictionary *postDictionary = postsDictionary[@"data"][0];
            STRPost *post = [parser parsePostFromDictionary:postDictionary];

            expect(post.text).to.equal(postDictionary[@"text"]);
        });
    });
});

SpecEnd
