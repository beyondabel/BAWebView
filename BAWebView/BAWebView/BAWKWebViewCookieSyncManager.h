//
//  BAWKWebViewCookieSyncManager.h
//  BAWebView
//
//  Created by BeyondAbel on 16/8/10.
//  Copyright © 2016年 abel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface BAWKWebViewCookieSyncManager : NSObject

@property (strong, nonatomic) WKProcessPool *processPool;

+ (BAWKWebViewCookieSyncManager *)shareManager;

//- (void)shareCookiesForWKWebView;

- (id)sharedCookie;

@end
