#import "STRPostsTableViewDelegate.h"
#import "STRPostTableViewCell.h"
#import "STRPost.h"

@interface STRPostsTableViewDelegate ()

@property (nonatomic, strong) STRPostTableViewCell *offscreenCell;

@end

@implementation STRPostsTableViewDelegate

#pragma mark - UITableViewDelegate

// See http://stackoverflow.com/questions/19132908/auto-layout-constraints-issue-on-ios7-in-uitableviewcell
// for detailed explanation about what's going on here
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.offscreenCell) {
        self.offscreenCell = [[STRPostTableViewCell alloc] init];
    }

    STRPost *post = self.posts[indexPath.row];

    self.offscreenCell.postTextLabel.text = post.text;
    self.offscreenCell.authorLabel.text = post.authorName;

    [self.offscreenCell setNeedsUpdateConstraints];
    [self.offscreenCell updateConstraintsIfNeeded];

    self.offscreenCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(self.offscreenCell.bounds));

    [self.offscreenCell setNeedsLayout];
    [self.offscreenCell layoutIfNeeded];

    CGFloat height = [self.offscreenCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    // this makes up for the cell separator
    height += 1.0f;

    return height;
}

@end
