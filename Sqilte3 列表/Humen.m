//
//  Humen.m
//  Sqilte3 列表
//
//  Created by Ibokan on 15/10/6.
//  Copyright (c) 2015年 YueWen. All rights reserved.
//

#import "Humen.h"

@implementation Humen

-(instancetype)initWithName:(NSString *)name Age:(NSInteger)age Tele:(NSString *)tele Address:(NSString *)address
{
    if (self = [super init])
    {
        self.name = name;
        self.age = age;
        self.tele = tele;
        self.address = address;
    }
    
    return self;
}


-(instancetype)initWithDict:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.humenId = [dictionary[@"id"] integerValue];
        self.name = dictionary[@"name"];
        self.age = [dictionary[@"age"] integerValue];
        self.tele = dictionary[@"tele"];
        self.address = dictionary[@"address"];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name = %@,age = %ld,tele = %@", self.name,self.age,self.tele];
}

@end
