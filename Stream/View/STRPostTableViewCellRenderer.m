#import "STRPostTableViewCellRenderer.h"
#import "STRPostTableViewCell.h"
#import "STRPost.h"
#import <UIImageView+AFNetworking.h>
#import <NSDate+DateTools.h>
#import <UIFont+OpenSans.h>

@implementation STRPostTableViewCellRenderer

- (void)configureCell:(STRPostTableViewCell *)cell withPost:(STRPost *)post
{
    [cell setAuthorName:post.authorName andHandle:post.authorHandle];
    cell.postTextLabel.text = post.text;
    [cell.avatarImageView setImageWithURL:post.authorAvatarURL
                         placeholderImage:[UIImage imageNamed:@"AvatarPlaceholder"]];
    cell.ageLabel.text = [post.createdDate shortTimeAgoSinceNow];
}

@end
