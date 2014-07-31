#import "STRPostsViewController.h"
#import "STRAppDotNetProxy.h"

// Posts table view
#import "STRPostTableViewCell.h"
#import "STRPostTableViewDataSource.h"
#import "STRPostsTableViewDelegate.h"

// Utils
#import <UIAlertView+Blocks.h>
#import <MBProgressHUD.h>
#import <UIFont+OpenSans.h>

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

    [self loadPosts];
}

#pragma mark - Loading Posts

- (void)loadPosts
{
    MBProgressHUD *spinner = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    spinner.labelFont = [UIFont openSansFontOfSize:[UIFont systemFontSize]];
    spinner.labelText = @"loading posts";

    [self.appDotNetProxy getPostsWithSuccessBlock:^(NSArray *posts) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        DDLogInfo(@"Loaded %d new posts", [posts count]);

        self.posts = posts;
        self.postsDataSource.posts = posts;
        self.postsDelegate.posts = posts;
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        [UIAlertView showWithTitle:@"Ouch!"
                           message:@"There's been an error...\nMaybe retry in a bit."
                 cancelButtonTitle:@"Later"
                 otherButtonTitles:@[ @"Retry Now" ]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              if (buttonIndex != [alertView cancelButtonIndex]) {
                                  [self loadPosts];
                              }
                          }];
    }];
}

@end
