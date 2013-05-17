//
//  ViewController.m
//  ZDYoutubeBrowserApp
//
//  Created by zedoul on 5/17/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import "ViewController.h"
#import "ZDYoutubeBrowser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    ZDYoutubeBrowser* det = [[ZDYoutubeBrowser alloc]
                             initWithNibName:@"ZDYoutubeBrowser" bundle:nil];
    assert(det);
    [self.navigationController pushViewController:det animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
