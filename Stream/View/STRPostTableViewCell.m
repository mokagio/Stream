#import "STRPostTableViewCell.h"
#import <Masonry.h>
#import <UIColor+FlatColors.h>
#import <UIFont+OpenSans.h>

static CGFloat kPadding = 10;
static CGFloat kAvatarDiameter = 46;

@interface STRPostTableViewCell ()

@property (nonatomic, strong, readwrite) UILabel *authorLabel;
@property (nonatomic, strong, readwrite) TTTAttributedLabel *postTextLabel;
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
        [self configureLabel:self.authorLabel];
        [self.contentView addSubview:self.authorLabel];

        self.postTextLabel = [[TTTAttributedLabel alloc] init];
        self.postTextLabel.numberOfLines = 0;
        self.postTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.postTextLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        [self configureLabel:self.postTextLabel];
        self.postTextLabel.linkAttributes = @{
                                              NSForegroundColorAttributeName: [UIColor flatAmethystColor],
                                              NSFontAttributeName: self.postTextLabel.font
                                              };
        [self.contentView addSubview:self.postTextLabel];

        self.avatarImageView = [[UIImageView alloc] init];
        self.avatarImageView.backgroundColor = [UIColor orangeColor];
        self.avatarImageView.layer.cornerRadius = kAvatarDiameter / 2;
        self.avatarImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.avatarImageView];

        self.ageLabel = [[UILabel alloc] init];
        [self configureLabel:self.ageLabel];
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
        make.width.and.height.mas_equalTo(kAvatarDiameter);
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

#pragma mark - Labels Settings

- (void)configureLabel:(UILabel *)label
{
    label.textColor = [UIColor flatWetAsphaltColor];
    CGFloat size = label.font.pointSize;
    label.font = [UIFont openSansFontOfSize:size];
}

@end
