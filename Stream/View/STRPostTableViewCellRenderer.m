#import "STRPostTableViewCellRenderer.h"
#import "STRPostTableViewCell.h"
#import "STRPost.h"
#import <UIImageView+AFNetworking.h>
#import <NSDate+DateTools.h>

@implementation STRPostTableViewCellRenderer

- (void)configureCell:(STRPostTableViewCell *)cell withPost:(STRPost *)post
{
    cell.authorLabel.text = [NSString stringWithFormat:@"@%@ %@", post.authorName, post.authorHandle];
    cell.postTextLabel.text = post.text;
    [cell.avatarImageView setImageWithURL:post.authorAvatarURL
                         placeholderImage:[UIImage imageNamed:@"AvatarPlaceholder"]];
    cell.ageLabel.text = [post.createdDate shortTimeAgoSinceNow];
}

@end
