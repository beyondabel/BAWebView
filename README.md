# BAWebView


###How do I get started?

Download BAWebView and try out the included iPhone example apps

BAWebView uses ARC and is based on UIWebView and WKWebView, which means it supports all iOS versions.

If you need a hand, you can contact us by e-mail.

Using BAWebView

1. Created BAWebView
    
        BAWebView *webview = [[BAWebView alloc] initWithFrame:self.view.frame];
        webview.delegate = self;
        webview.viewController = self;
        [self.view addSubview:webview];

2. implement UIWebViewDelegate protocol
    
        - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
            return YES;
        }

        - (void)webViewDidStartLoad:(UIWebView *)webView {
    
        }
    
        - (void)webViewDidFinishLoad:(UIWebView *)webView {
        
        }
    
        - (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
        
        }

###License

BAWebView is released under the MIT license.
