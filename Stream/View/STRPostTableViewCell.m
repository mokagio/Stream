#import "STRPostTableViewCell.h"
#import <Masonry.h>

static CGFloat kPadding = 10;

@interface STRPostTableViewCell ()

@property (nonatomic, strong, readwrite) UILabel *postTextLabel;

@end

@implementation STRPostTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.postTextLabel = [[UILabel alloc] init];
        self.postTextLabel.numberOfLines = 0;
        self.postTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.postTextLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];

    self.postTextLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.postTextLabel.bounds);
}

#pragma mark - Auto Layout

- (void)updateConstraints
{
    UIView *superview = self.contentView;

    [self.postTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(superview).with.offset(kPadding);
        make.bottom.and.right.equalTo(superview).with.offset(-kPadding);
    }];

    [super updateConstraints];
}

@end
