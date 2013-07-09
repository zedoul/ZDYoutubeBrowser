//
//  ZDYoutubeBrowser.m
//  ZDYoutubeBrowserApp
//
//  Created by zedoul on 5/17/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import "ZDYoutubeBrowser.h"

#import "MGBox.h"
#import "MGScrollView.h"

#import "JSONModelLib.h"
#import "VideoModel.h"

#import "PhotoBox.h"

@interface ZDYoutubeBrowser () <UISearchBarDelegate,PhotoBoxDelegate>
{
    IBOutlet MGScrollView* scroller;
    MGBox* searchBox;
    
    NSArray* videos;
}

@end

@implementation ZDYoutubeBrowser

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //setup the scroll view
    scroller.contentLayoutMode = MGLayoutTableStyle;
    scroller.bottomPadding = 8;
    scroller.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
    
    //setup the search box
    searchBox = [MGBox boxWithSize:CGSizeMake(320,44)];
    searchBox.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    
    //prepare up the first search
    searchBar.showsCancelButton = NO;
    [searchBar setBackgroundImage:[UIImage imageNamed:@"Youtube_SearchBar"]];
    [searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchYoutubeVideosForTerm:(NSString*)term
{
#ifdef ZDYOUTUBEBROWSER
    NSLog(@"Searching for '%@' ...", term);
#endif
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    
    //URL escape the term
    term = [term stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //make HTTP call
    NSString* searchCall = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos?q=%@&max-results=50&alt=json", term];
    
    [JSONHTTPClient getJSONFromURLWithString: searchCall
                                  completion:^(NSDictionary *json, JSONModelError *err) {
                                      
                                      //got JSON back
#ifdef ZDYOUTUBEBROWSER
                                      NSLog(@"Got JSON from web: %@", json);
#endif
                                      
                                      if (err) {
                                          [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:[err localizedDescription]
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Close"
                                                            otherButtonTitles: nil] show];
                                          return;
                                      }
                                      
                                      //initialize the models
                                      videos = [VideoModel arrayOfModelsFromDictionaries:
                                                json[@"feed"][@"entry"]
                                                ];
                                      if (videos) {
                                          //show the videos
                                          [self showVideos];
                                      } else {
                                          [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:@"Please try different keywords or try again later"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Close"
                                                            otherButtonTitles: nil] show];
                                      }
                                  }];
}

-(NSString*)youtubeID:(VideoModel*)video
{
    VideoLink* link = video.link[0];
    
    NSString* videoId = nil;
    NSArray *queryComponents = [link.href.query componentsSeparatedByString:@"&"];
    for (NSString* pair in queryComponents) {
        NSArray* pairComponents = [pair componentsSeparatedByString:@"="];
        if ([pairComponents[0] isEqualToString:@"v"]) {
            videoId = pairComponents[1];
            break;
        }
    }
    
    if (!videoId) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Video ID not found in video URL" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil]show];
        return nil;
    }
    
    return videoId;
}

-(void)showVideos
{
    //clean the old videos
    [scroller.boxes removeObjectsInRange:NSMakeRange(0, scroller.boxes.count)];
    
    //add boxes for all videos
    for (int i=0;i<videos.count;i++) {
        //get the data
        VideoModel* video = videos[i];
        MediaThumbnail* thumb = video.thumbnail[0];
        
        //create a box
        NSLog(@"title [%@]", video.title);
        NSLog(@"seconds [%@]", video.seconds);
        PhotoBox *box = [PhotoBox photoBoxForURL:thumb.url title:video.title];
        box.delegate = self;
        box->video = video;
        box.onTap = ^{
            if([_delegate respondsToSelector:@selector(youtubeBrowser:select:title:)]) {
                [_delegate youtubeBrowser:self
                                   select:[self youtubeID:video]
                                    title:video.title];
            }
        };
        [box setFrame:CGRectMake(0, 0, 305, 88)];
        
        //add the box
        [scroller.boxes addObject:box];
    }
    
    //re-layout the scroll view
    [scroller layoutWithSpeed:0.3 completion:nil];
}

-(IBAction)closeBtnClicked:(id)sender
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton =NO;
    
    if([_delegate respondsToSelector:@selector(youtubeBrowserDidClose:)]) {
        [_delegate youtubeBrowserDidClose:self];
    }
}

#pragma mark - UISearchDisplayController Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    self.queryString = [searchText retain];
//    self.queryStringLabel.text = self.queryString;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)sBar
{
    searchBar.showsCancelButton = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)sBar
{
    searchBar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sBar
{
    [self searchYoutubeVideosForTerm:sBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)sBar
{
    [self closeBtnClicked:nil];
}

#pragma mark - 

-(void)photoBox:(PhotoBox*)box down:(VideoModel*)video
{
    if([_delegate respondsToSelector:@selector(youtubeBrowser:down:)]) {
        [_delegate youtubeBrowser:self down:[self youtubeID:video]];
    }
}

@end
