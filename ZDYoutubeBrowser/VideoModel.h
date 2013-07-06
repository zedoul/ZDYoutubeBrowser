//
//  VideoModel.h
//  JSONModelDemo
//
//  Created by Marin Todorov on 02/12/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"

#import "VideoLink.h"
#import "MediaThumbnail.h"

@interface VideoModel : JSONModel

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* viewCount;
@property (strong, nonatomic) NSArray* author;
@property (strong, nonatomic) NSString* updated;
@property (strong, nonatomic) NSDictionary* seconds;
@property (strong, nonatomic) NSArray<VideoLink>* link;
@property (strong, nonatomic) NSArray<MediaThumbnail>* thumbnail;

@end
