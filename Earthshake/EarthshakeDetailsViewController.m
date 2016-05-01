//
//  EarthshakeDetailsViewController.m
//  Earthshake
//
//  Created by Andrey Paunov on 2016-04-29.
//  Copyright © 2016 AP. All rights reserved.
//

#import "EarthshakeDetailsViewController.h"
#import "EarthshakeItem.h"

@interface EarthshakeDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *earthshakeWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation EarthshakeDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.earthshakeWebView.delegate = self;
    self.earthshakeWebView.hidden = YES;

    [self.spinner startAnimating];

    NSURL *url = [NSURL URLWithString:self.detailURLString];
    NSURLRequest *requestObject = [NSURLRequest requestWithURL:url];

    [self.earthshakeWebView loadRequest:requestObject];
}

#pragma mark WebView delegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinner stopAnimating];
    self.earthshakeWebView.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.spinner stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
