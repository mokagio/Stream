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

- (NSArray *)parsePostsFromDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) { return nil; }

    NSArray *rawPosts = dictionary[@"data"];
    if (!rawPosts) { return nil; }

    NSMutableArray *posts = [NSMutableArray array];
    [rawPosts enumerateObjectsUsingBlock:^(NSDictionary *rawPost, NSUInteger idx, BOOL *stop) {
        STRPost *post = [self parsePostFromDictionary:rawPost];
        [posts addObject:post];
    }];

    return [NSArray arrayWithArray:posts];
}

@end
