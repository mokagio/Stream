#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>

@interface STRPostTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *authorLabel;
@property (nonatomic, strong, readonly) TTTAttributedLabel *postTextLabel;
@property (nonatomic, strong, readonly) UIImageView *avatarImageView;
@property (nonatomic, strong, readonly) UILabel *ageLabel;

@end
