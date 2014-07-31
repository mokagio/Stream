#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>

@interface STRPostTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) id<TTTAttributedLabelDelegate> touchableLabelDelegate;

@end
