//
//  YYLocationPickerView.h
//  YYPickerViewDemo
//
//  Created by 房俊杰 on 2017/2/26.
//  Copyright © 2017年 上海涵予信息科技有限公司. All rights reserved.
//
/**
 
 需要导入FMDB三方库
 
 */
#import <UIKit/UIKit.h>

@class YYLocationPickerView,YYLocationPickerViewModel;
/** 级别 */
typedef NS_ENUM(NSInteger,YYLocationPickerViewLevel){
    YYLocationPickerViewLevelProvince = 1,//一级 省
    YYLocationPickerViewLevelCity = 2,//二级 省市
    YYLocationPickerViewLevelArea = 3//三级 省市区
};

@protocol YYLocationPickerViewDelegate <NSObject>

@optional
- (void)locationPickerView:(YYLocationPickerView *)locationPickerView didSelectedLocation:(NSString *)location locationID:(NSString *)locationID;

@end

@interface YYLocationPickerView : UIView


/**
 初始化
 
 @param level 级别
 @param delegate 代理
 @return self
 */
- (instancetype)initWithLevel:(YYLocationPickerViewLevel)level andDelegate:(__weak id<YYLocationPickerViewDelegate>)delegate;

/**
 显示
 */
- (void)show;



@end


@interface YYLocationPickerViewModel : NSObject

/** 省 */
@property (nonatomic,strong) NSString *province;
/** 市 */
@property (nonatomic,strong) NSString *city;
/** 县区 */
@property (nonatomic,strong) NSString *area;


@end
