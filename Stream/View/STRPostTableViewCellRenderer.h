#import <Foundation/Foundation.h>

@class STRPost;
@class STRPostTableViewCell;

@interface STRPostTableViewCellRenderer : NSObject

- (void)configureCell:(STRPostTableViewCell *)cell withPost:(STRPost *)post;

@end
