#import "STRPostsTableViewDelegate.h"
#import "STRPostTableViewCell.h"
#import "STRPostTableViewCellRenderer.h"

@interface STRPostsTableViewDelegate ()

@property (nonatomic, strong) STRPostTableViewCell *offscreenCell;
@property (nonatomic, strong) STRPostTableViewCellRenderer *renderer;

@end

@implementation STRPostsTableViewDelegate

- (id)init
{
    self = [super init];
    if (!self) { return nil; }

    self.renderer = [[STRPostTableViewCellRenderer alloc] init];

    return self;
}

#pragma mark - UITableViewDelegate

// See http://stackoverflow.com/questions/19132908/auto-layout-constraints-issue-on-ios7-in-uitableviewcell
// for detailed explanation about what's going on here
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.offscreenCell) {
        self.offscreenCell = [[STRPostTableViewCell alloc] init];
    }

    STRPost *post = self.posts[indexPath.row];
    [self.renderer configureCell:self.offscreenCell withPost:post];

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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat reachedHeight = scrollView.contentOffset.y + scrollView.bounds.size.height;
    CGFloat maxHeight = scrollView.contentSize.height;

    BOOL hasReachedBottom = reachedHeight >= maxHeight;

    if (hasReachedBottom) {
        if (self.scrollToBottomBlock) { self.scrollToBottomBlock(); }
    }
}


@end
