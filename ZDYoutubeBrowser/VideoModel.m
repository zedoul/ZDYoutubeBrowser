//
//  VideoModel.m
//  JSONModelDemo
//
//  Created by Marin Todorov on 02/12/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
            @"media$group.media$thumbnail":@"thumbnail",
            @"title.$t": @"title",
            @"author":@"author",
            @"gd$rating.numRaters":@"review",
            @"updated.$t":@"updated",
            @"media$group.yt$duration":@"seconds",
            @"yt$statistics.viewCount":@"viewCount",
            }];
}

@end
