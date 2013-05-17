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
            }];
}

@end
