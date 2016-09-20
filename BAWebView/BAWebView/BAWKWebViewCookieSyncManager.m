//
//  BAWKWebViewCookieSyncManager.m
//  BAWebView
//
//  Created by BeyondAbel on 16/8/10.
//  Copyright © 2016年 abel. All rights reserved.
//

#import "BAWKWebViewCookieSyncManager.h"

@implementation BAWKWebViewCookieSyncManager

+ (instancetype)shareManager{
    static BAWKWebViewCookieSyncManager* _wkckSyncManager;
    if (_wkckSyncManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _wkckSyncManager = [[self alloc] initManager];
        });
    }
    return _wkckSyncManager;
}

- (instancetype)initManager {
    if (self = [super init]) {
        _processPool = [[WKProcessPool alloc] init];
    }
    
    return self;
}

- (WKProcessPool *)processPool{
    if (_processPool == nil) {
        _processPool = [[WKProcessPool alloc] init];
        
        [self sharedCookie];
    }
    return _processPool;
}

- (nullable id)sharedCookie {
    NSArray *arrCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    
    return [dictCookies objectForKey:@"Cookie"];
}

- (void)shareCookiesForWKWebView {
    if (NSClassFromString(@"WKWebView")) {
        
        // cookie注入
//        WKUserContentController* userContentController = WKUserContentController.new;
//        WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource: @"document.cookie ='TeskCookieKey1=TeskCookieValue1';document.cookie = 'TeskCookieKey2=TeskCookieValue2';"injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//        
//        [userContentController addUserScript:cookieScript];
//        WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
//        webViewConfig.userContentController = userContentController;
//        WKWebView * webView = [[WKWebView alloc] initWithFrame:CGRectMake(/*set your values*/) configuration:webViewConfig];

//        - (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//            [webView evaluateJavaScript:@"document.cookie ='TeskCookieKey1=TeskCookieValue1';" completionHandler:^(id result, NSError *error) {
//                //...
//            }];
//        }
        
//        NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.skyfox.org/printCookie.php"]];
//        [request setValue:[NSString stringWithFormat:@"%@=%@",@"testwkcookie", @"testwkcookievalue"] forHTTPHeaderField:@"Cookie"];
        
        
//        WKWebViewConfiguration* wkWebConf = [[WKWebViewConfiguration alloc] init];
//        
//        wkWebConf.processPool = [BAWKWebViewCookieSyncManager shareManager].processPool;
//        
//        WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConf];
//        
//        NSURL* shareCookieURL = [NSURL URLWithString:@"http://www.o2planet.net/"];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:shareCookieURL];
//        
//        NSArray *arrCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//        
//        NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
//        
//        [request setValue: [dictCookies objectForKey:@"Cookie"] forHTTPHeaderField: @"Cookie"];
//        
//        [wkWebView loadRequest:request];
    }
}

@end
