//
//  MediaThumbnail.h
//  YTBrowser
//
//  Created by Marin Todorov on 03/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"

@protocol MediaThumbnail @end

@interface MediaThumbnail : JSONModel

@property (strong, nonatomic) NSURL* url;
@property (assign, nonatomic) int width;
@property (assign, nonatomic) int height;
@property (strong, nonatomic) NSString* time;

@end
