#import "STRPostsViewController.h"
#import "STRAppDotNetProxy.h"
#import "STRPost.h"
#import "STRPostTableViewCell.h"
#import "STRPostTableViewDataSource.h"
#import "STRPostsTableViewDelegate.h"

@interface STRPostsViewController ()

@property (nonatomic, strong) STRAppDotNetProxy *appDotNetProxy;
@property (nonatomic, strong) NSArray *posts;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) STRPostTableViewDataSource *postsDataSource;
@property (nonatomic, strong) STRPostsTableViewDelegate *postsDelegate;

@end

@implementation STRPostsViewController

- (id)initWithAppDotNetProxy:(STRAppDotNetProxy *)proxy
{
    NSParameterAssert(proxy);

    self = [super init];
    if (!self) { return nil; }

    self.appDotNetProxy = proxy;
    self.title = @"Stream";
    self.postsDataSource = [[STRPostTableViewDataSource alloc] init];
    self.postsDelegate = [[STRPostsTableViewDelegate alloc] init];

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
    self.tableView.dataSource = self.postsDataSource;
    self.tableView.delegate = self.postsDelegate;
    self.tableView.estimatedRowHeight = 100;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.appDotNetProxy getPostsWithSuccessBlock:^(NSArray *posts) {
        DDLogInfo(@"Loaded %d new posts", [posts count]);
        self.posts = posts;
        self.postsDataSource.posts = posts;
        self.postsDelegate.posts = posts;
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        // TODO: alert user
    }];
}

@end
