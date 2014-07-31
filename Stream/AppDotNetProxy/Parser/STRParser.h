#import <Foundation/Foundation.h>

@class STRPost;

@interface STRParser : NSObject

- (STRPost *)parsePostFromDictionary:(NSDictionary *)dictionary;

- (NSArray *)parsePostsFromDictionary:(NSDictionary *)dictionary;

@end
