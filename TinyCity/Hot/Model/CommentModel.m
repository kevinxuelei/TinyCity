//
//  CommentModel.m
//  TinyCity
//
//  Created by lanou3g on 15/11/24.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

@dynamic reviewers,byReviewers,thumbsUp,commentContent;

+ (NSString *)parseClassName
{
    return @"CommentModel";
}

@end
