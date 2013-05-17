//
//  VideoLink.h
//  JSONModelDemo
//
//  Created by Marin Todorov on 02/12/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"

@protocol VideoLink @end

@interface VideoLink : JSONModel

@property (strong, nonatomic) NSURL* href;

@end
