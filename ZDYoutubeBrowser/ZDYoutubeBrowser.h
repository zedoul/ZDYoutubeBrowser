//
//  ZDYoutubeBrowser.h
//  ZDYoutubeBrowserApp
//
//  Created by zedoul on 5/17/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZDYoutubeBrowserDelegate;

@interface ZDYoutubeBrowser : UIViewController
{
    IBOutlet UISearchBar* searchBar;
}

@property (nonatomic,assign) id <ZDYoutubeBrowserDelegate> delegate;

-(IBAction)closeBtnClicked:(id)sender;

@end

@protocol ZDYoutubeBrowserDelegate <NSObject>
@required
@optional
-(void)youtubeBrowser:(ZDYoutubeBrowser*)browser select:(NSString*)keyID;
-(void)youtubeBrowser:(ZDYoutubeBrowser*)browser down:(NSString*)keyID;
-(void)youtubeBrowserDidClose:(ZDYoutubeBrowser*)browser;
@end
