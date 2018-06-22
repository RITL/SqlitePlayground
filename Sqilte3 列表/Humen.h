//
//  Humen.h
//  Sqilte3
//
//  Created by YueWen on 15/10/6.
//  Copyright (c) 2015年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Humen : NSObject

@property(nonatomic,strong)NSString * name;//姓名

@property(nonatomic,assign)NSInteger age;//年龄

@property(nonatomic,strong)NSString * tele;//电话

@property(nonatomic,strong)NSString * address;//地址

@property(nonatomic,assign)NSInteger humenId;//id


/**
 *  便利初始化方法
 *
 *  @param name    初始name
 *  @param age     初始age
 *  @param tele    初始tele
 *  @param address 初始地址
 *
 *  @return 初始化好的Humen对象
 */
-(instancetype)initWithName:(NSString *)name Age:(NSInteger)age Tele:(NSString *)tele Address:(NSString *)address;


/**
 *  便利初始化方法
 *
 *  @param dictionary 存储数据的字典
 *
 *  @return 初始化好的Humen对象
 */
-(instancetype)initWithDict:(NSDictionary *)dictionary;

@end
