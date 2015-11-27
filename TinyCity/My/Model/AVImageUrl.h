//
//  AVImageUrl.h
//  TinyCity
//
//  Created by lanou3g on 15/11/25.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "AVUser.h"

@interface AVImageUrl : AVUser
@property (nonatomic, copy) NSString *imageUrl;

+ (AVImageUrl *)user;
@end
