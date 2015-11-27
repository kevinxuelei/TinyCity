//
//  HomeModel.m
//  TinyCity
//
//  Created by lanou3g on 15/11/12.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if (self) {
        
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.profile_image = [aDecoder decodeObjectForKey:@"profile_image"];
        self.created_at = [aDecoder decodeObjectForKey:@"created_at"];
        self.videouri = [aDecoder decodeObjectForKey:@"videouri"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.width = [aDecoder decodeObjectForKey:@"width"];
        self.height = [aDecoder decodeObjectForKey:@"height"];
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.image1 = [aDecoder decodeObjectForKey:@"image1"];
        
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.profile_image forKey:@"profile_image"];
    [aCoder encodeObject:self.created_at forKey:@"created_at"];
    [aCoder encodeObject:self.videouri forKey:@"videouri"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.width forKey:@"width"];
    [aCoder encodeObject:self.height forKey:@"height"];
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.image1 forKey:@"image1"];
    
}


@end

