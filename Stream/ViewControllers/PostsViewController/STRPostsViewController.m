#import "STRPostsViewController.h"
#import "STRAppDotNetProxy.h"
#import "STRPost.h"
#import "STRPostTableViewCell.h"

@interface STRPostsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) STRAppDotNetProxy *appDotNetProxy;
@property (nonatomic, strong) NSArray *posts;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) STRPostTableViewCell *offscreenCell;

@end

static NSString *kPostCellIdentifier = @"PostCellIdentifier";

@implementation STRPostsViewController

- (id)initWithAppDotNetProxy:(STRAppDotNetProxy *)proxy
{
    NSParameterAssert(proxy);

    self = [super init];
    if (!self) { return nil; }

    self.appDotNetProxy = proxy;
    self.title = @"Stream";

    return self;
}

- (id)init
{
    return [self initWithAppDotNetProxy:nil];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[STRPostTableViewCell class] forCellReuseIdentifier:kPostCellIdentifier];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.appDotNetProxy getPostsWithSuccessBlock:^(NSArray *posts) {
        DDLogInfo(@"Loaded %d new posts", [posts count]);
        self.posts = posts;
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        // TODO: alert user
    }];
}

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
    STRPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPostCellIdentifier
                                                            forIndexPath:indexPath];
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

    [self.offscreenCell setNeedsUpdateConstraints];
    [self.offscreenCell updateConstraintsIfNeeded];

    self.offscreenCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.offscreenCell.bounds));

    [self.offscreenCell setNeedsLayout];
    [self.offscreenCell layoutIfNeeded];

    CGFloat height = [self.offscreenCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    // this makes up for the cell separator
    height += 1.0f;
    
    return height;
}

@end
