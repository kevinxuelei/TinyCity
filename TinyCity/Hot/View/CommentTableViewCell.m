//
//  CommentTableViewCell.m
//  TinyCity
//
//  Created by lanou3g on 15/11/24.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell


- (void)setDataA:(NSMutableArray *)dataA
{
    _rew_Label.text = [dataA objectAtIndex:0];
    _comment_Text.text = [dataA objectAtIndex:1];
    _comment_Text.userInteractionEnabled = NO;
    _comment_Text.font = [UIFont systemFontOfSize:13];
//    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    _create_Time.text = [dataA objectAtIndex:2];
    _info.text = @":";
}
@end
