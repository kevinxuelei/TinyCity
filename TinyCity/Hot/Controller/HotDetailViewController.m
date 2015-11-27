//
//  HotDetailViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "HotDetailViewController.h"
#define KArticleContentUrl @"http://api.en8848.com/GetContentInfo.php"


@interface HotDetailViewController ()

@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, strong)HotHeaderContentModel *contentModel;

@end

@implementation HotDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = self.model.title;
    
    [self loadData];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    self.webView = webView;
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.webView loadHTMLString:self.contentModel.newstext baseURL:nil];

}
-(void)loadData{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:KArticleContentUrl]];
    [request setHTTPMethod:@"POST"];
    NSString *bodyString = [NSString stringWithFormat:@"contentid=%@&tbname=yingyu",self.model.id];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (data != nil) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        HotHeaderContentModel *model = [[HotHeaderContentModel alloc] init];
        [model setValuesForKeysWithDictionary:object];
        self.contentModel = model;
    }
    
}


@end
