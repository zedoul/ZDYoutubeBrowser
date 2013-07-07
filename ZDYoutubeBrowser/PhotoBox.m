//
//  Created by matt on 28/09/12.
//  Additions by Marin Todorov for YouTube JSONModel tutorial

#import "PhotoBox.h"

@implementation PhotoBox

#pragma mark - Init

- (void)setup {

  // positioning
  self.topMargin = 8;
  self.leftMargin = 8;

  // background
  self.backgroundColor = [UIColor blackColor];
    //[UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];
}

#pragma mark - Factories

+ (PhotoBox *)photoBoxForURL:(NSURL*)url title:(NSString*)title
{
  // box with photo number tag
  PhotoBox *box = [PhotoBox boxWithSize:CGSizeMake(150,100)];
  box.titleString = title;
    
  // add a loading spinner
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  spinner.center = CGPointMake(box.width / 2, box.height / 2);
  spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
      | UIViewAutoresizingFlexibleRightMargin
      | UIViewAutoresizingFlexibleBottomMargin
      | UIViewAutoresizingFlexibleLeftMargin;
  spinner.color = UIColor.lightGrayColor;

  [box addSubview:spinner];
  [spinner startAnimating];
  
  // do the photo loading async, because internets
  __weak id wbox = box;
  box.asyncLayoutOnce = ^{
      [wbox loadPhotoFromURL:url];
  };

  return box;
}

#pragma mark - Photo box loading
- (void)loadPhotoFromURL:(NSURL*)url
{
    
    // fetch the remote photo
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // do UI stuff back in UI land
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // ditch the spinner
        UIActivityIndicatorView *spinner = self.subviews.lastObject;
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        
        // failed to get the photo?
        if (!data) {
            self.alpha = 0.3;
            return;
        }
        
        // got the photo, so lets show it
        UIImage *image = [UIImage imageWithData:data];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        [imageView setFrame:CGRectMake(10, 10, self.size.height-20, self.size.height-20)];
        imageView.alpha = 0;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleHeight;
        
        // fade the image in
        [UIView animateWithDuration:0.2 animations:^{
            imageView.alpha = 1;
        }];
        
        UILabel* desclabel = [[UILabel alloc]
                             initWithFrame:CGRectMake(91,
                                                      11,
                                                      168,
                                                      34)];
        desclabel.backgroundColor = [UIColor clearColor];
        //desclabel.editable = NO;
        desclabel.lineBreakMode = NSLineBreakByWordWrapping;
        desclabel.numberOfLines = 10;
        desclabel.userInteractionEnabled = NO;
        desclabel.text = self.titleString;
        desclabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        desclabel.textColor = [UIColor whiteColor];
        [self addSubview:desclabel];
        
        UILabel *updatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(186,
                                                                         70,
                                                                         60,
                                                                         10)];
        updatedLabel.backgroundColor = [UIColor clearColor];
        updatedLabel.userInteractionEnabled = NO;
        updatedLabel.numberOfLines = 1;
        updatedLabel.adjustsFontSizeToFitWidth = YES;
        updatedLabel.text = [[video.author[0] objectForKey:@"name"] objectForKey:@"$t"];
        updatedLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
        updatedLabel.textColor = [UIColor whiteColor];

        [self addSubview:updatedLabel];
        
        
        UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(186,
                                                                         55,
                                                                         90,
                                                                         10)];
        authorLabel.textColor = [UIColor whiteColor];
        authorLabel.numberOfLines = 1;
        NSArray* t = [video.updated componentsSeparatedByString:@"T"];
        authorLabel.backgroundColor = [UIColor blackColor];
        authorLabel.adjustsFontSizeToFitWidth = YES;
        authorLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
        authorLabel.text = t[0];////video.updated;
        [self addSubview:authorLabel];
        
        UILabel *secondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(91,
                                                                         70,
                                                                         90,
                                                                         10)];
        secondsLabel.textColor = [UIColor whiteColor];
        secondsLabel.numberOfLines = 1;
        secondsLabel.adjustsFontSizeToFitWidth = NO;
        secondsLabel.backgroundColor = [UIColor blackColor];
        secondsLabel.adjustsFontSizeToFitWidth = YES;
        secondsLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:
                             [[video.seconds objectForKey:@"seconds"] integerValue]-1];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        NSDateComponents *components = [calendar components:NSUIntegerMax
                                                   fromDate:timerDate];
        secondsLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",
                             [components hour],
                             [components minute],
                             [components second]];
        [self addSubview:secondsLabel];
        
        UILabel *viewLabel = [[UILabel alloc] initWithFrame:CGRectMake(91,
                                                                          55,
                                                                          70,
                                                                          10)];
        viewLabel.textColor = [UIColor whiteColor];
        viewLabel.numberOfLines = 1;
        viewLabel.adjustsFontSizeToFitWidth = YES;
        viewLabel.adjustsFontSizeToFitWidth = YES;
        viewLabel.backgroundColor = [UIColor blackColor];
        viewLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
        //NSLog(@"det [%d]",[[video.viewCount] integerValue]);
        viewLabel.text = [NSString stringWithFormat:@"%@ views", video.viewCount];
        [self addSubview:viewLabel];
        
        
        actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [actionButton setImage:[UIImage imageNamed:@"Button_Down"]
                      forState:UIControlStateNormal];
        [actionButton addTarget:self
                         action:@selector(downBtnClicked:)
               forControlEvents:UIControlEventTouchDown];
        actionButton.frame = CGRectMake(240.0, 0.0, 60.0, 88.0);
        [self addSubview:actionButton];
    });
}

-(void)downBtnClicked:(id)sender
{
    if([_delegate respondsToSelector:@selector(photoBox:down:)]) {
        [_delegate photoBox:self down:self->video];
    }
}

@end
