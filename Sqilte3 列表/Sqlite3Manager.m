//
//  Sqlite3Manager.m
//  Sqilte3 列表
//
//  Created by YueWen on 15/10/6.
//  Copyright (c) 2015年 YueWen. All rights reserved.
//

#import "Sqlite3Manager.h"
#import "Humen.h"
#import "FMDatabase.h"

@interface Sqlite3Manager ()

@property(nonatomic,strong)FMDatabase * database;//第三方的数据库

@property(nonatomic,strong)NSMutableArray * mHumen;

@end

@implementation Sqlite3Manager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //初始化数据数组
        self.mHumen = [NSMutableArray array];
        
        //创建数据库
        [self createDatabase];
        
        //打开数据库
        [self openDatabase];
        
    }
    return self;
}



+(instancetype)shareSqlite3Manager
{
    static Sqlite3Manager * sqliteManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sqliteManager = [[Sqlite3Manager alloc]init];
        
    });
    
    return sqliteManager;
}

/**
 *  创建数据库
 */
-(void)createDatabase
{
    //获得当前的沙盒路径
    NSString * path = [NSString stringWithFormat:@"%@/Documents/app.db",NSHomeDirectory()];
    
    //根据路径初始化数据库
    self.database = [FMDatabase databaseWithPath:path];

}


/**
 *  打开数据库
 */
-(void)openDatabase
{
    //如果打开成功
    if ([self.database open])
    {
        //初始化sql语句
        NSString * sql = @"create table if not exists t_humen (id integer primary key autoincrement,name varchar(30),age integer,tele varchar(100),address varchar(100))";
        
        //执行操作
        if ([self.database executeUpdate:sql])//执行成功
        {
            NSLog(@"创建表成功");
        }

        else
        {
            NSLog(@"创建失败！");
        }
        
    }
    
    else
    {
        NSLog(@"打开失败！");
    }

}

/**
 *  重写humen的get方法
 *
 *  @return 存储humen对象的数组
 */
-(NSArray *)humen
{
    return [NSArray arrayWithArray:self.mHumen];
}



/**
 *  加载所有的数据
 */
-(void)loadMHumen
{
    //删除所有的元素
    [self.mHumen removeAllObjects];
    
    //定义SQL语句
    NSString * sql = @"select * from t_humen";
    
    //获得数据
    FMResultSet * resultSet = [self.database executeQuery:sql];
    
    //遍历处理
    while ([resultSet next])
    {
        //用字典接收
        NSDictionary * temp_dict = [resultSet resultDictionary];
        
        //创建一个对象转模型
        Humen * humen = [[Humen alloc]initWithDict:temp_dict];
        
        //添加到数组
        [self.mHumen addObject:humen];
        
    }
    
}


/**
 *  增加人
 *
 *  @param humen 需要增加的Humen模型
 */
-(void)addHumenToSqlite:(Humen *)humen
{
    //为数组添加元素对象
    [self.mHumen addObject:humen];
    
    //设置sql语句
    NSString* sql = [NSString stringWithFormat:@"insert into t_humen values(NULL,'%@',%ld,'%@','%@')",humen.name,humen.age,humen.tele,humen.address];
    
    //执行插入语句
    if ([self.database executeUpdate:sql])
    {
        NSLog(@"插入成功！");
    }
    else
    {
        NSLog(@"插入失败！");
    }
}



/**
 *  删除指定id的人对象
 *
 *  @param index 删除对象的id
 */
-(void)deleteHumenFromSqlite:(NSInteger)index
{
    //获取当前对象的id
    NSInteger ID = ((Humen *) self.mHumen[index - 1]).humenId;
    
    //移除对象
    [self.mHumen removeObjectAtIndex:index - 1];
    
    //设置sql语句
    NSString * sql = [NSString stringWithFormat:@"delete from t_humen where id=%ld",ID];
    
    //执行语句
    if ([self.database executeUpdate:sql])
    {
        NSLog(@"删除成功！");
    }
    else
    {
        NSLog(@"删除失败！");
    }
}




/**
 *  更新数据
 *
 *  @param humen 需要更新的Humen模型
 */
-(void)updateHumenFromSqlite:(Humen *)humen withIndex:(NSInteger)index
{
    //获取当前的对象的ID
    NSInteger ID = ((Humen *)self.humen[index - 1]).humenId;
    
    //数组替换
    [self.mHumen replaceObjectAtIndex:index - 1 withObject:humen];
    
    //sql语句
    NSString * sql = [NSString stringWithFormat:@"update t_humen set name='%@',age=%ld,tele='%@',address='%@' where id=%ld",humen.name,humen.age,humen.tele,humen.address,ID];
    
    if ([self.database executeUpdate:sql])
    {
        NSLog(@"更新成功！");
    }
    else
    {
        NSLog(@"更新失败！");
    }
}




/**
 *  根据姓名查询名字
 *
 *  @param name 查询的名字
 */
-(void)selectHumenFromWithName:(NSString *)name
{
    //可变数组存储符合条件的对象
    NSMutableArray * mutableHumen = [NSMutableArray array];
    
    //只需在数组中查询即可，不需要在执行数据库
    for (Humen * humen in self.mHumen)
    {
        if ([humen.name isEqualToString:name])
        {
            //添加到数组
            [mutableHumen addObject:humen];
        }
    }
    
    //改变当前的数组
    self.mHumen = mutableHumen;
}



/**
 *  消除对象的时候关闭数据库
 */
-(void)dealloc
{
    //关闭数据库
    [self.database close];
}

@end
