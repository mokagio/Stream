#import "STRPostsViewController.h"
#import "STRAppDotNetProxy.h"
#import "STRPost.h"

@interface STRPostsViewController () <UITableViewDataSource>

@property (nonatomic, strong) STRAppDotNetProxy *appDotNetProxy;
@property (nonatomic, strong) NSArray *posts;

@property (nonatomic, strong) UITableView *tableView;

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kPostCellIdentifier];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.appDotNetProxy getPostsWithSuccessBlock:^(NSArray *posts) {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPostCellIdentifier
                                                            forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kPostCellIdentifier];
    }

    STRPost *post = self.posts[indexPath.row];

    cell.textLabel.text = post.text;

    return cell;
}

@end
