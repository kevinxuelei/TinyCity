//
//  CommentTableViewCell.h
//  TinyCity
//
//  Created by lanou3g on 15/11/24.
//  Copyright © 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rew_Label;
@property (weak, nonatomic) IBOutlet UITextView *comment_Text;

@property (weak, nonatomic) IBOutlet UILabel *info;

@property (weak, nonatomic) IBOutlet UILabel *create_Time;

@property (nonatomic, strong) NSMutableArray *dataA;
@end
