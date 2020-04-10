//
//  YYLocationDataBase.m
//  YYPickerViewDemo
//
//  Created by 房俊杰 on 2017/2/26.
//  Copyright © 2017年 上海涵予信息科技有限公司. All rights reserved.
//

#import "YYLocationDataBase.h"

#import "FMDatabase.h"

@interface YYLocationDataBase ()
/** 单例数据库 */
@property (nonatomic,strong) FMDatabase *dataBase;

@end

@implementation YYLocationDataBase

static YYLocationDataBase *_sharedDataBase;


+ (YYLocationDataBase *)sharedDataBase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataBase = [[YYLocationDataBase alloc] init];
    });
    return _sharedDataBase;
}

//创建数据库
- (void)createDataBase
{
    self.dataBase = [[FMDatabase alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"YYLocationPickerView.bundle/location"ofType:@"db"]];
    if([self.dataBase open])
    {
        NSLog(@"区域选择数据库创建打开成功");
    }
    else
    {
        NSLog(@"区域选择数据库创建打开失败");
    }
}

//查询数据
- (NSArray *)selectValueWithPid:(NSString *)pid
{
    [self.dataBase open];
    FMResultSet *res;
    if([pid integerValue] == 0)
    {
        res = [self.dataBase executeQuery:@"select *from location where pid=? order by hot desc,key asc,id asc",pid];
    }
    else
    {
        res = [self.dataBase executeQuery:@"select *from location where pid=?",pid];
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([res next]) {
        YYLocationDataBaseModel *model = [[YYLocationDataBaseModel alloc] init];
        model.ID = [res stringForColumn:@"id"];
        model.title = [res stringForColumn:@"title"];
        model.pid = [res stringForColumn:@"pid"];
        [array addObject:model];
    }
    [self.dataBase close];
    return array;
}

@end

@implementation YYLocationDataBaseModel

- (instancetype)initWithID:(NSString *)ID andTitle:(NSString *)title andPid:(NSString *)pid
{
    self = [super init];
    if (self) {
        
        self.ID = ID;
        self.title = title;
        self.pid = pid;
    }
    return self;
}
@end

