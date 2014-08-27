#import "STRPostTableViewCellRenderer.h"
#import "STRPostTableViewCell.h"
#import "STRPost.h"
#import "STRAppDotNetProxy.h"
#import <NSDate+DateTools.h>
#import <UIFont+OpenSans.h>

@interface STRPostTableViewCellRenderer ()

@property (nonatomic, strong) STRAppDotNetProxy *appDotNetProxy;
@property (nonatomic, strong) UIImage *placeHolderImage;

@end

@implementation STRPostTableViewCellRenderer

- (id)init
{
    self = [super init];
    if (!self) { return nil; }

    self.appDotNetProxy = [STRAppDotNetProxy configuredProxy];
    self.placeHolderImage = [UIImage imageNamed:@"AvatarPlaceholder"];

    return self;
}

- (void)configureCell:(STRPostTableViewCell *)cell withPost:(STRPost *)post
{
    [cell setAuthorName:post.authorName andHandle:post.authorHandle];
    cell.postTextLabel.text = post.text;
    cell.ageLabel.text = [post.createdDate shortTimeAgoSinceNow];
    cell.avatarImageView.image = self.placeHolderImage;

    [self.appDotNetProxy getAvatarImageForPost:post
                              withSuccessBlock:^(UIImage *image) {
                                  cell.avatarImageView.image = image;
                              } failureBlock:^(NSError *error) {
                                  DDLogError(@"Failed downloading avatar image. Error: %@", error.localizedDescription);
                              }];
}

@end
