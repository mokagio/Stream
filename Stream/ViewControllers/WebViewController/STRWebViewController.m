#import "STRWebViewController.h"
#import <Masonry.h>

@interface STRWebViewController ()

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
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
}

@end
