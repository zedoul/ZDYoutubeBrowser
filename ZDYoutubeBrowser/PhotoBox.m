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
  self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];

  // shadow
  self.layer.shadowColor = [UIColor colorWithWhite:0.12 alpha:1].CGColor;
  self.layer.shadowOffset = CGSizeMake(0, 0.5);
  self.layer.shadowRadius = 1;
  self.layer.shadowOpacity = 1;
  self.layer.rasterizationScale = 1.0;
  self.layer.shouldRasterize = YES;
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
    [self addSubview:imageView];

    imageView.size = self.size;
    imageView.alpha = 0;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth
    | UIViewAutoresizingFlexibleHeight;

    // fade the image in
    [UIView animateWithDuration:0.2 animations:^{
    imageView.alpha = 1;
    }];


    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = self.titleString;
    label.font = [UIFont boldSystemFontOfSize:16.0];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];

    label.layer.shadowColor = [UIColor colorWithWhite:0.12 alpha:1].CGColor;
    label.layer.shadowOffset = CGSizeMake(0, 0.5);
    label.layer.shadowRadius = 1;
    label.layer.shadowOpacity = 1;
    label.layer.rasterizationScale = 1.0;
    label.layer.shouldRasterize = YES;

  });
}

@end
