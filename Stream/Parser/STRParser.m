#import "STRParser.h"
#import "STRPost.h"

@implementation STRParser

- (STRPost *)parsePostFromDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) { return nil; }

    NSString *text = dictionary[@"text"];
    if (!text) { return nil; }

    STRPost *post = [[STRPost alloc] init];
    post.text = text;

    return post;
}

@end
