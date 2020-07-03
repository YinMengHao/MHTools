//
//  MHWebController.m
//  SuiXingYou
//
//  Created by HelloWorld on 2019/1/10.
//  Copyright © 2019 SuiXingYou. All rights reserved.
//

#import "MHWebController.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"
#import "MHTools.h"


@interface MHWebController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property(nonatomic,strong)UIProgressView * progressView;

@end

@implementation MHWebController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (self.callBack) {
        self.callBack();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
        } else {
            make.top.offset(0);
        }
    }];
    [self loadDataFromType];
}

#pragma mark - laod data
- (void)loadDataFromType {
    if (self.urlString) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
        [_webView loadRequest:request];
    }
}

- (void)backToLastVC {
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - lazy
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configure = [WKWebViewConfiguration new];
        configure.userContentController = [WKUserContentController new];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configure.preferences = preferences;
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configure];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

    }
    return _webView;
}

- (UIProgressView*)progressView {
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, KNavigationBarHeight, KScreenWidth, 5)];
        _progressView.progressTintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progressView.hidden = NO;
        self.progressView.progress = [change[@"new"] floatValue];
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            });
            self.progressView.hidden = YES;
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        if ([self.webView.title containsString:@"豆豆兼职用户协议"]) {
            self.title = @"豆豆兼职注册协议";
        } else {
            self.title = self.webView.title;
        }
    } else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    [webView loadRequest:navigationAction.request];
    
    return nil;
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

-(void)dealloc{
    
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self cleanCacheAndCookie];
}

@end
