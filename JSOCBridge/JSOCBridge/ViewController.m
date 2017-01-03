//
//  ViewController.m
//  JSOCBridge
//
//  Created by 李林 on 2017/1/3.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ViewController.h"
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>

@interface ViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // common Init
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    webView.delegate = self;
    self.webView = webView;
    
    // webView
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    // Bridge
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [self.bridge callHandler:@"js_handler" data:@"<data from objc>" responseCallback:^(id responseData) {
        NSLog(@"收到来自js的回调数据 %@", responseData);
    }];
}

#pragma mark - load
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = request.URL.absoluteString;
    
    // 这里把app协议的请求拦截下来处理
    if([urlStr hasPrefix:@"app://"]){
        NSString *content = [urlStr substringFromIndex:6];
        NSLog(@"%@", content);
        return NO;
    }
    return YES;
}



@end
