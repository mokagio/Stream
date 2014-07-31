#import <UIKit/UIKit.h>

typedef void (^STRPostsTableViewDelegateBlock)();

@interface STRPostsTableViewDelegate : NSObject <UITableViewDelegate>

@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) STRPostsTableViewDelegateBlock scrollToBottomBlock;

@end
