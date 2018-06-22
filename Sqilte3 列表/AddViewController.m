//
//  AddViewController.m
//  Sqilte3 列表
//
//  Created by Ibokan on 15/10/6.
//  Copyright (c) 2015年 YueWen. All rights reserved.
//

#import "AddViewController.h"
#import "Sqlite3Manager.h"
#import "Humen.h"

@interface AddViewController ()

@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet UITextField *ageText;
@property (strong, nonatomic) IBOutlet UITextField *teleText;
@property (strong, nonatomic) IBOutlet UITextField *addressText;

@property (nonatomic,strong) Sqlite3Manager * sqliteManager;

//更新时专用
@property(strong,nonatomic)Humen * humen;
@property(nonatomic,strong)NSIndexPath * index;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //实例化单例属性
    self.sqliteManager = [Sqlite3Manager shareSqlite3Manager];

    //设置导航的右上角按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addHumenToSqliteFromAddViewController)];
    
    //表示代表更新视图
    if (self.humen)
    {
        self.navigationItem.title = @"更新视图";
        //赋值
        self.nameText.text = self.humen.name;
        self.ageText.text = [NSString stringWithFormat:@"%ld",self.humen.age];
        self.teleText.text = self.humen.tele;
        self.addressText.text = self.humen.address;
    }
    
    else
    {
        self.navigationItem.title = @"添加视图";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addHumenToSqliteFromAddViewController
{
    
    //初始化humen实例
    Humen * humen = [[Humen alloc]initWithName:self.nameText.text Age:[self.ageText.text intValue] Tele:self.teleText.text Address:self.addressText.text];
    
    //表示更新
    if (self.humen)
    {
        //更新到数据库
        [self.sqliteManager updateHumenFromSqlite:humen withIndex:self.index.row + 1];
    }
    
    //表示添加
    else
    {
        //添加到数据库sqlite
        [self.sqliteManager addHumenToSqlite:humen];
    }

    //调回原页面
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
