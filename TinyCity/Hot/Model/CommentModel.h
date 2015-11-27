//
//  CommentModel.h
//  TinyCity
//
//  Created by lanou3g on 15/11/24.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "AVObject.h"

@interface CommentModel : AVObject<AVSubclassing>

@property (nonatomic, copy) NSString *reviewers; // 评论者
@property (nonatomic, copy) NSString *byReviewers; // 被评论者
@property (nonatomic, copy) NSMutableArray *thumbsUp; // 点赞人
@property (nonatomic, copy) NSMutableArray *commentContent; // 评论内容

@end
