//
//  ViewController.m
//  AVCaptureDemo
//
//  Created by tederen on 2017/10/20.
//  Copyright © 2017年 zhiyuehl. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,strong) WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.userContentController = [[WKUserContentController alloc] init];
    
    //注册两个对象
    [config.userContentController addScriptMessageHandler:self name:@"UserInfo"];
    [config.userContentController addScriptMessageHandler:self name:@"Test2"];
    config.processPool = [[WKProcessPool alloc] init];
    
    //初始化
    _webView = [[WKWebView alloc]initWithFrame:[UIScreen mainScreen].bounds configuration:config];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    _webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:self.webView];
    
    
    //加载H5
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"demo1" ofType:@"html"];
    [self.webView loadFileURL:[NSURL fileURLWithPath:htmlPath] allowingReadAccessToURL:[NSURL fileURLWithPath:htmlPath]];
    
}
#pragma mark ------------------------WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //JS传过来的数据
    if ([message.name isEqualToString:@"UserInfo"]) {
        NSLog(@"test1传值-------------%@",message.body);
    }
    
    //JS调用OC方法
    if ([message.name isEqualToString:@"Test2"]) {
        [self callCamera:message];
    }
}


#pragma mark ------------------------js

- (void)callCamera:(WKScriptMessage *)message
{
    NSLog(@"test2JS传值----%@",message.body);
    
    [self ocInvokeJSMethod];
}
//OC调用JS方法
- (void)ocInvokeJSMethod
{
    NSString *js = [NSString stringWithFormat:@"onOCChangeMethod('775445353@qq.com','123123')"];
    [_webView evaluateJavaScript:js completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"---%@",error.localizedDescription);
    }];
}
//调用弹出框函数
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    //此处调用OC弹出框
}
//调用确认框函数
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    //此处调用OC弹出框
}
//调用输入框函数
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(nonnull NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(NSString * _Nullable))completionHandler
{
    //此处调用OC弹出框
}




@end
