//
//  HumenTableViewController.m
//  Sqilte3 列表
//
//  Created by Ibokan on 15/10/6.
//  Copyright (c) 2015年 YueWen. All rights reserved.
//

#import "HumenTableViewController.h"
#import "Sqlite3Manager.h"
#import "Humen.h"

@interface HumenTableViewController ()

@property(nonatomic,strong)Sqlite3Manager * sqliteManager;

@end

@implementation HumenTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化单例
    self.sqliteManager = [Sqlite3Manager shareSqlite3Manager];
    
    //添加导航栏的右按钮，回调方法为 toAddViewController
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toAddViewController)];
    
    //添加导航栏的左按钮，回调方法为 toSearchViewController
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toSearchViewController)];
}

//页面将要跳回动画结束时
-(void)viewWillAppear:(BOOL)animated
{
    //重新加载数据库中的所有数据
    [self.sqliteManager loadMHumen];
    
    //刷新列表
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - barButton target action
-(void)toAddViewController
{
    //获取storyboard
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    //根据storyboard创建控制对象
    UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
    
    //跳转界面
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)toSearchViewController
{
    //准备alertController
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"搜索" message:@"请填入搜索的名字" preferredStyle:UIAlertControllerStyleAlert];
    
    //添加文本框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    
    //添加搜索的动作按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"搜索" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //获取搜索的名字
        NSString * name = alert.textFields[0].text;
        
        //搜索
        [self.sqliteManager selectHumenFromWithName:name];
        
        //刷新列表
        [self.tableView reloadData];
        
        //跳回
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    //添加取消的动作按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        //跳回
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    //跳出
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - Table view data source
/**
 *  返回组数，分组的情况下，因为不分组，所以返回1
 *
 *  @param tableView 当前的tableView
 *
 *  @return 组数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

/**
 *  组的行数
 *
 *  @param tableView 当前的tableView
 *  @param section   组的个数
 *
 *  @return 返回每部分的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.sqliteManager.humen.count;

}


/**
 *  cell显示的内容
 *
 *  @param tableView 当前的tableView
 *  @param indexPath 当前的位置
 *
 *  @return 打包好的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //获取模型
    Humen * humen = self.sqliteManager.humen[indexPath.row];
    
    //创建表格cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //简单赋值
    cell.textLabel.text = humen.name;
    
    return cell;
}


/**
 *  点击行的时候
 *
 *  @param tableView 当前的tableView
 *  @param indexPath 当前的位置
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取当前的模型
    Humen * humen = self.sqliteManager.humen[indexPath.row];
    
    //获得当前的storyboard
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    //获得跳转的ViewController
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
    
    //KVC赋值
    [vc setValue:humen forKey:@"humen"];
    [vc setValue:indexPath forKey:@"index"];
    
    //跳转
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 *  列表视图能够编辑
 *
 *  @param tableView 当前的tableView
 *  @param indexPath 当前的位置
 *
 *  @return YES表示可以编辑  NO表示不可以编辑
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}



/**
 *  当前的编辑模式进行相应的操作
 *
 *  @param tableView    当前的tableView
 *  @param editingStyle 编辑的风格
 *  @param indexPath    当前的位置
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //删除当前的对象
        [self.sqliteManager deleteHumenFromSqlite:indexPath.row + 1];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

@end
