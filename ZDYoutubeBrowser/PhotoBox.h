//
//  Created by matt on 28/09/12.
//  Additions by Marin Todorov for YouTube JSONModel tutorial

#import "MGBox.h"
#import "VideoModel.h"

@protocol PhotoBoxDelegate;

@interface PhotoBox : MGBox
{
    @public
    VideoModel* video;
}

@property (nonatomic,assign) id <PhotoBoxDelegate> delegate;

+(PhotoBox *)photoBoxForURL:(NSURL*)url title:(NSString*)title;

@property (strong, nonatomic) NSString* titleString;

@end

@protocol PhotoBoxDelegate <NSObject>
@required
@optional
-(void)photoBox:(PhotoBox*)box down:(VideoModel*)video;
@end
