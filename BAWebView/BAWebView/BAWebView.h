//
//  UIWebView.h
//  BAWebView
//
//  Created by BeyondAbel on 16/8/10.
//  Copyright © 2016年 abel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BAWebView : UIView

@property (nonatomic, weak) id<UIWebViewDelegate> delegate;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIViewController *viewController;

- (void)loadRequest:(NSURLRequest *)request;

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *error))completionHandler;

- (void)fetchTitle:(void (^)(NSString *title))title;

- (BOOL)canGoBack;

- (void)goBack;

@end
