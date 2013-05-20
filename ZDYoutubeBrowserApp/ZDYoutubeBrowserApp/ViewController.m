//
//  ViewController.m
//  ZDYoutubeBrowserApp
//
//  Created by zedoul on 5/17/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import "ViewController.h"
#import "ZDYoutubeBrowser.h"

@interface ViewController () <ZDYoutubeBrowserDelegate>

@property (nonatomic, retain) ZDYoutubeBrowser* browser;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _browser = [[ZDYoutubeBrowser alloc]
                             initWithNibName:@"ZDYoutubeBrowser" bundle:nil];
    _browser.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

-(IBAction)openBtnClicked:(id)sender
{
    [self.navigationController pushViewController:_browser animated:NO];
}

#pragma mark - ZDYoutubeDelegate

-(void)youtubeBrowser:(ZDYoutubeBrowser*)browser select:(NSString*)keyID
{
    NSLog(@"Selected ID [%@]",keyID);
}

-(void)youtubeBrowserDidClose:(ZDYoutubeBrowser*)browser
{
    [self.navigationController popToViewController:self animated:NO];
}

@end
