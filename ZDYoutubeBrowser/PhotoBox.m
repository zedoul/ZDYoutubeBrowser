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

    [imageView setFrame:CGRectMake(10, 10, self.size.height-20, self.size.height-20)];
    imageView.alpha = 0;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth
    | UIViewAutoresizingFlexibleHeight;

    // fade the image in
    [UIView animateWithDuration:0.2 animations:^{
    imageView.alpha = 1;
    }];

    UITextView* label = [[UITextView alloc]
                           initWithFrame:CGRectMake(91,
                                                    11,
                                                    168,
                                                    60)];
      label.backgroundColor = [UIColor clearColor];
      label.editable = NO;
      label.userInteractionEnabled = NO;
      label.text = self.titleString;
      label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:15.0];
      label.textColor = [UIColor whiteColor];
      [self addSubview:label];
      
      UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
      [button setImage:[UIImage imageNamed:@"Button_Down"] forState:UIControlStateNormal];
      [button addTarget:self
                 action:@selector(downBtnClicked:)
       forControlEvents:UIControlEventTouchDown];
      button.frame = CGRectMake(260.0, 0.0, 40.0, 88.0);
      [self addSubview:button];
  });
}

-(void)downBtnClicked:(id)sender
{
    if([_delegate respondsToSelector:@selector(photoBox:down:)]) {
        [_delegate photoBox:self down:self->video];
    }
}

@end
