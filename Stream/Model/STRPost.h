#import <Foundation/Foundation.h>

@interface STRPost : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *authorHandle;
@property (nonatomic, strong) NSURL *authorAvatarURL;
@property (nonatomic, copy) NSDate *createdDate;

@end
