//
//  WebVideoViewController.h
//  YTBrowser
//
//  Created by Marin Todorov on 09/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@protocol WebVideoViewControllerDelegate;

@interface WebVideoViewController : UIViewController

@property (weak, nonatomic) VideoModel* video;

@property (nonatomic,assign) id <WebVideoViewControllerDelegate> delegate;

-(IBAction)backBtnClicked:(id)sender;
-(IBAction)downBtnClicked:(id)sender;

@end

@protocol WebVideoViewControllerDelegate <NSObject>

@required
-(void)webVideo:(WebVideoViewController*)controller target:(NSString*)keyID;

@optional

@end