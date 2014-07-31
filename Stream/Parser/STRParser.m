#import "STRParser.h"
#import "STRPost.h"

@interface STRParser ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation STRParser

- (instancetype)init
{
    self = [super init];
    if (!self) { return nil; }

    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";

    return self;
}

- (STRPost *)parsePostFromDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) { return nil; }

    NSString *text = dictionary[@"text"];
    if (!text) { return nil; }

    if (!dictionary[@"user"]) { return nil; }

    STRPost *post = [[STRPost alloc] init];
    post.text = text;
    post.authorName = dictionary[@"user"][@"name"];
    post.authorHandle = dictionary[@"user"][@"username"];
    NSURL *url = [NSURL URLWithString:dictionary[@"user"][@"avatar_image"][@"url"]];
    post.authorAvatarURL = url;
    post.createdDate = [self.dateFormatter dateFromString:dictionary[@"created_at"]];

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
