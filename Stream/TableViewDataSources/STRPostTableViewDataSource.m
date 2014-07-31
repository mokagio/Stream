#import "STRPostTableViewDataSource.h"
#import "STRPostTableViewCell.h"
#import "STRPost.h"

static NSString *kPostCellIdentifier = @"PostCellIdentifier";

@implementation STRPostTableViewDataSource

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.posts count];
}

// See http://stackoverflow.com/questions/19132908/auto-layout-constraints-issue-on-ios7-in-uitableviewcell
// for detailed explanation about what's going on here
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STRPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPostCellIdentifier];
    if (!cell) {
        cell = [[STRPostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:kPostCellIdentifier];
    }

    STRPost *post = self.posts[indexPath.row];

    cell.postTextLabel.text = post.text;

    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

@end
