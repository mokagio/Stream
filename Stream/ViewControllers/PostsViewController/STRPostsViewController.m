#import "STRPostsViewController.h"
#import "STRAppDotNetProxy.h"
#import "STRWebViewController.h"

// Posts table view
#import "STRPostTableViewCell.h"
#import "STRPostTableViewDataSource.h"
#import "STRPostsTableViewDelegate.h"

// Utils
#import <UIAlertView+Blocks.h>
#import <MBProgressHUD.h>
#import <UIFont+OpenSans.h>
#import <TTTAttributedLabel.h>

@interface STRPostsViewController () <TTTAttributedLabelDelegate>

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

    // Don't show any text on the back button when coming back to this view controller
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];

    self.postsDataSource = [[STRPostTableViewDataSource alloc] init];
    self.postsDataSource.touchableLabelDelegate = self;
    self.postsDelegate = [[STRPostsTableViewDelegate alloc] init];
    __weak typeof(self) weakSelf = self;
    self.postsDelegate.scrollToBottomBlock = ^{
        [weakSelf loadMorePosts];
    };

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
    [self showLoadingPostsSpinner];
    [self.appDotNetProxy getPostsWithSuccessBlock:^(NSArray *posts) {
        [self handleGetPostsSuccess:posts];
    } failureBlock:^(NSError *error) {
        [self handleGetPostsFailure:error];
    }];
}

- (void)loadMorePosts
{
    [self showLoadingPostsSpinner];
    [self.appDotNetProxy getPostsAfterPost:[self.posts lastObject]
                          withSuccessBlock:^(NSArray *posts) {
                              NSUInteger previousPostsCount = [self.posts count];
                              [self handleGetPostsSuccess:posts];
                              NSIndexPath *lastOldPostIndexPath = [NSIndexPath indexPathForRow:previousPostsCount - 1
                                                                                 inSection:0];
                              [self.tableView scrollToRowAtIndexPath:lastOldPostIndexPath
                                                    atScrollPosition:UITableViewScrollPositionTop
                                                            animated:YES];
                          } failureBlock:^(NSError *error) {
                              [self handleGetPostsFailure:error];
                          }];
}

- (void)showLoadingPostsSpinner
{
    MBProgressHUD *spinner = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    spinner.labelFont = [UIFont openSansFontOfSize:[UIFont systemFontSize]];
    spinner.labelText = @"loading posts";
}

- (void)handleGetPostsSuccess:(NSArray *)posts
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    DDLogInfo(@"Loaded %d new posts", [posts count]);

    NSMutableArray *mergedPosts = [NSMutableArray arrayWithArray:self.posts];
    [mergedPosts addObjectsFromArray:posts];

    self.posts = [NSArray arrayWithArray:mergedPosts];
    self.postsDataSource.posts = self.posts;
    self.postsDelegate.posts = self.posts;
    [self.tableView reloadData];
}

- (void)handleGetPostsFailure:(NSError *)error
{
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
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [self loadWebViewWithURL:url];
}

#pragma mark - Load Post Link

- (void)loadWebViewWithURL:(NSURL *)url
{
    STRWebViewController *webViewController = [[STRWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
