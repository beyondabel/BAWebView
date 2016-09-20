//
//  UIWebView.m
//  BAWebView
//
//  Created by BeyondAbel on 16/8/10.
//  Copyright © 2016年 abel. All rights reserved.
//

#import "BAWebView.h"
#import <WebKit/WebKit.h>
#import "BAWKWebViewCookieSyncManager.h"

@interface BAWebView () <WKNavigationDelegate, WKUIDelegate, UIAlertViewDelegate> {
    NSURL *openURL;
}

@end

@implementation BAWebView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if([[[UIDevice currentDevice] systemVersion] integerValue] >= 8) {
            WKUserContentController* userContentController = WKUserContentController.new;
            
            WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
            webViewConfig.userContentController = userContentController;
            webViewConfig.processPool = [BAWKWebViewCookieSyncManager shareManager].processPool;

            WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:[self cookieJavaScriptString] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
            
            [userContentController addUserScript:cookieScript];
            
            _webView = (UIWebView *)[[WKWebView alloc] initWithFrame:self.bounds configuration:webViewConfig];
            [self addSubview:_webView];
            ((WKWebView *)_webView).navigationDelegate = self;
            ((WKWebView *)_webView).UIDelegate = self;
            
        } else {
            _webView = [[UIWebView alloc] initWithFrame:self.bounds];
            [self addSubview:_webView];
            _webView.delegate = self.delegate;
        }
        
        [self removeDiskCache];
    }
    return self;
}

- (void)removeDiskCache {
    double systemVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
    if(systemVersion >= 9) {
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                        WKWebsiteDataTypeDiskCache,
                                                        WKWebsiteDataTypeOfflineWebApplicationCache,
                                                        WKWebsiteDataTypeMemoryCache,
                                                        WKWebsiteDataTypeLocalStorage,
                                                        WKWebsiteDataTypeCookies,
                                                        WKWebsiteDataTypeSessionStorage,
                                                        WKWebsiteDataTypeIndexedDBDatabases,
                                                        WKWebsiteDataTypeWebSQLDatabases
                                                        ]];
        //你可以选择性的删除一些你需要删除的文件 or 也可以直接全部删除所有缓存的type
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                                   modifiedSince:dateFrom completionHandler:^{
                                                       // code
                                                   }];
        
    }
    
    
    
    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                               NSUserDomainMask, YES)[0];
    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                            objectForKey:@"CFBundleIdentifier"];
    NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
    NSString *webKitFolderInCaches = [NSString
                                      stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
    NSString *webKitFolderInCachesfs = [NSString
                                        stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
    
    NSError *error;
    
    if (systemVersion >= 8) {
        /* iOS8.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
    } else {
        /* iOS7.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
    }
}

- (void)setDelegate:(id<UIWebViewDelegate>)delegate {
    _delegate = delegate;
    if ([_webView isKindOfClass:[UIWebView class]]) {
        _webView.delegate = _delegate;
    }
}

- (NSString *)cookieJavaScriptString {
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    //取出cookie
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        NSString *excuteJSString = [NSString stringWithFormat:@"document.cookie='%@=%@';", cookie.name, cookie.value];
        [cookieString appendString:excuteJSString];
    }
    //执行js
    return cookieString;
}

- (NSString *)cookieString {
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    //取出cookie
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        NSString *excuteJSString = [NSString stringWithFormat:@"%@=%@;", cookie.name, cookie.value];
        [cookieString appendString:excuteJSString];
    }
    //执行js
    return cookieString;
}

#pragma mark - WKNavigationDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    return nil;
}


/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
//    debug(@"%s", __FUNCTION__);
}

/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    //    NSLog(@"%s", __FUNCTION__);
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:(UIWebView *)webView];
    }
}


/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    //    NSLog(@"%s", __FUNCTION__);
}

/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    //    NSLog(@"%s", __FUNCTION__);
}

/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    // 允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if([[navigationAction.request.URL scheme] isEqualToString:@"weixin"] ) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if ([[navigationAction.request.URL scheme] isEqualToString:@"tel"]) {
        openURL = navigationAction.request.URL;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定需要拨打电话吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if ([self.delegate webView:(UIWebView *)webView shouldStartLoadWithRequest:navigationAction.request navigationType:(UIWebViewNavigationType)navigationAction.navigationType]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//    NSLog(@"%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self.viewController presentViewController:alert animated:YES completion:nil];
//    [self presentViewController:alert animated:YES completion:NULL];
//    NSLog(@"%@", message);
}

// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
//    NSLog(@"%s", __FUNCTION__);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self.viewController presentViewController:alert animated:YES completion:nil];
//    [self presentViewController:alert animated:YES completion:NULL];
    
//    NSLog(@"%@", message);
}

// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
//    NSLog(@"%s", __FUNCTION__);
    
//    NSLog(@"%@", prompt);
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:defaultText message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.textColor = [UIColor redColor];
//    }];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler([[alert.textFields lastObject] text]);
//    }]];
    
//    [self presentViewController:alert animated:YES completion:NULL];
}


#pragma mark - Private
- (NSMutableURLRequest *)addCookieAddTokenByURL:(NSURL *)url {
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [mutableRequest setValue:[self cookieString] forHTTPHeaderField:@"Cookie"];
    return mutableRequest;
}

#pragma mark - Public
- (void)goBack {
    [_webView goBack];
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *error))completionHandler {
    if ([_webView isKindOfClass:[UIWebView class]]) {
        if (completionHandler) {
            completionHandler([_webView stringByEvaluatingJavaScriptFromString:javaScriptString], nil);
        }
    } else {
        [(WKWebView *)_webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    }
}

- (BOOL)canGoBack {
    return [_webView canGoBack];
}

- (void)loadRequest:(NSURLRequest *)request {
    [_webView loadRequest:[self addCookieAddTokenByURL:request.URL]];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
    [_webView loadHTMLString:string baseURL:baseURL];
}

- (void)fetchTitle:(void (^)(NSString *))titleBlock {
    if ([_webView isKindOfClass:[UIWebView class]]) {
        if (titleBlock) {
            titleBlock([_webView stringByEvaluatingJavaScriptFromString:@"document.title"]);
        }
    } else {
        if (titleBlock) {
            titleBlock(((WKWebView *)_webView).title);
        }
        
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:openURL];
    }
}

@end
