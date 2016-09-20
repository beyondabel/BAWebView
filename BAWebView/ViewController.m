//
//  ViewController.m
//  BAWebView
//
//  Created by BeyondAbel on 16/8/10.
//  Copyright © 2016年 abel. All rights reserved.
//

#import "ViewController.h"
#import "BAWebView.h"

@interface ViewController () <UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    BAWebView *webview = [[BAWebView alloc] initWithFrame:self.view.frame];
    webview.delegate = self;
    webview.viewController = self;
    [self.view addSubview:webview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {

}

@end
