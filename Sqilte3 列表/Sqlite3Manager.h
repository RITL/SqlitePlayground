//
//  Sqlite3Manager.h
//  Sqilte3 列表
//
//  Created by Ibokan on 15/10/6.
//  Copyright (c) 2015年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Humen;

/**
 *  管理数据库操作的Manager
 */
@interface Sqlite3Manager : NSObject

/**
 *  存储数据库中的数据数组
 */
@property(nonatomic,strong,readonly)NSArray * humen;


/**
 *  加载数据库中所有的数据
 */
-(void)loadMHumen;


/**
 *  单例方法
 *
 *  @return 返回单例
 */
+(instancetype)shareSqlite3Manager;

/**
 *  增加人
 *
 *  @param humen 需要增加的Humen模型
 */
-(void)addHumenToSqlite:(Humen *)humen;

/**
 *  更新数据
 *
 *  @param humen 需要更新的Humen模型
 */
-(void)updateHumenFromSqlite:(Humen *)humen withIndex:(NSInteger)index;


/**
 *  根据下标即id删除
 *
 *  @param index 当前的id
 */
-(void)deleteHumenFromSqlite:(NSInteger)index;


/**
 *  根据姓名查询名字
 *
 *  @param name 查询的名字
 */
-(void)selectHumenFromWithName:(NSString *)name;

@end
