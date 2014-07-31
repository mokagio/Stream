#import "STRPostTableViewCell.h"
#import <Masonry.h>

static CGFloat kPadding = 10;

@interface STRPostTableViewCell ()

@property (nonatomic, strong, readwrite) UILabel *authorLabel;
@property (nonatomic, strong, readwrite) UILabel *postTextLabel;
@property (nonatomic, strong, readwrite) UIImageView *avatarImageView;
@property (nonatomic, strong, readwrite) UILabel *ageLabel;

@end

@implementation STRPostTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

        self.authorLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.authorLabel];

        self.postTextLabel = [[UILabel alloc] init];
        self.postTextLabel.numberOfLines = 0;
        self.postTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.postTextLabel];

        self.avatarImageView = [[UIImageView alloc] init];
        self.avatarImageView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.avatarImageView];

        self.ageLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.ageLabel];
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

    [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(superview).with.offset(kPadding);
        make.width.and.height.equalTo(@46);
    }];

    [self.authorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview).with.offset(kPadding);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(kPadding);
        make.right.equalTo(self.ageLabel.mas_left).with.offset(-kPadding);
        make.height.equalTo(@40);
    }];

    [self.postTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorLabel.mas_bottom).with.offset(kPadding);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(kPadding);
        make.bottom.and.right.equalTo(superview).with.offset(-kPadding);
    }];

    [self.ageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview).with.offset(-kPadding);
        make.top.equalTo(superview).with.offset(kPadding);
        make.height.equalTo(@40);
    }];

    [super updateConstraints];
}

@end
