#import <UIKit/UIKit.h>

@interface STRPostTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *authorLabel;
@property (nonatomic, strong, readonly) UILabel *postTextLabel;
@property (nonatomic, strong, readonly) UIImageView *avatarImageView;
@property (nonatomic, strong, readonly) UILabel *ageLabel;

@end
