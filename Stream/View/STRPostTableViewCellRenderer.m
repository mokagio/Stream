#import "STRPostTableViewCellRenderer.h"
#import "STRPostTableViewCell.h"
#import "STRPost.h"

@implementation STRPostTableViewCellRenderer

- (void)configureCell:(STRPostTableViewCell *)cell withPost:(STRPost *)post
{
    cell.authorLabel.text = [NSString stringWithFormat:@"@%@ %@", post.authorName, post.authorHandle];
    cell.postTextLabel.text = post.text;
    cell.avatarImageView.image = [UIImage imageNamed:@"AvatarPlaceholder"];
}

@end
