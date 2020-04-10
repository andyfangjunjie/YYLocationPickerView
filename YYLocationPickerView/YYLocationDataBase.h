//
//  YYLocationDataBase.h
//  YYPickerViewDemo
//
//  Created by 房俊杰 on 2017/2/26.
//  Copyright © 2017年 上海涵予信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYLocationDataBase : NSObject

/**
 单例数据库
 
 @return self
 */
+ (YYLocationDataBase *)sharedDataBase;

//创建数据库
- (void)createDataBase;
//查询数据
- (NSArray *)selectValueWithPid:(NSString *)pid;

@end

@interface YYLocationDataBaseModel : NSObject
/** 区域id */
@property (nonatomic,strong) NSString *ID;
/** 区域 */
@property (nonatomic,strong) NSString *title;
/** 区域父类id */
@property (nonatomic,strong) NSString *pid;
/** 城市数组 */
@property (nonatomic,strong) NSMutableArray *cityArrray;

/**
 初始化数据
 
 @param ID 区域id
 @param title 区域
 @param pid 区域父类id
 @return self
 */
- (instancetype)initWithID:(NSString *)ID andTitle:(NSString *)title andPid:(NSString *)pid;

@end
