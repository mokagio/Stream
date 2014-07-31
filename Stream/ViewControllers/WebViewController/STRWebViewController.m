#import "STRWebViewController.h"
#import <Masonry.h>
#import <MBProgressHUD.h>

@interface STRWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation STRWebViewController

- (id)initWithURL:(NSURL *)URL
{
    NSParameterAssert(URL);

    self = [super init];
    if (!self) { return nil; }

    self.URL = URL;

    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
