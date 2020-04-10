//
//  YYLocationPickerView.m
//  YYPickerViewDemo
//
//  Created by 房俊杰 on 2017/2/26.
//  Copyright © 2017年 上海涵予信息科技有限公司. All rights reserved.
//

#import "YYLocationPickerView.h"
#import "YYLocationDataBase.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT 200
#define HEIGHT_BUTTON 40

#define ANIMATION_DURATION 0.3f

@interface YYLocationPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
/** 代理 */
@property (nonatomic,weak) __weak id<YYLocationPickerViewDelegate> delegate;
/** 级别 */
@property (nonatomic,assign) YYLocationPickerViewLevel level;
/** 背景 */
@property (nonatomic,strong) UIView *bgBlackView;
/** pickerView */
@property (nonatomic,strong) UIPickerView *pickerView;
/** 省 */
@property (nonatomic,strong) NSArray *provinceArray;
/** 市 */
@property (nonatomic,strong) NSArray *cityArray;
/** 区县 */
@property (nonatomic,strong) NSArray *areaArray;
/** 区域model */
@property (nonatomic,strong) YYLocationPickerViewModel *model;
/** 选中区域id */
@property (nonatomic,strong) NSString *locationID;


@end

@implementation YYLocationPickerView

- (instancetype)init
{
    if(self == [super init])
    {
        [[YYLocationDataBase sharedDataBase] createDataBase];
        [self setup];
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithLevel:(YYLocationPickerViewLevel)level andDelegate:(__weak id<YYLocationPickerViewDelegate>)delegate
{
    self.delegate = delegate;
    self.level = level;
    return [self init];
}
#pragma mark - 初始化
- (void)setup
{
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, WIDTH, HEIGHT);
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.subviews.firstObject;
    [topView addSubview:self.bgBlackView];
    [topView addSubview:self];
    [self addSubview:self.pickerView];
    
    [self layoutIfNeeded];
}
- (void)setupUI
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT_BUTTON)];
    bgView.backgroundColor = [UIColor orangeColor];
    [self addSubview:bgView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(0, 0, 60, CGRectGetHeight(bgView.frame));
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.tag = 1;
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelButton];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureButton.frame = CGRectMake(CGRectGetWidth(self.frame)-60, 0, 60, CGRectGetHeight(bgView.frame));
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.tag = 2;
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sureButton];
    
    [self layoutIfNeeded];
    
}

- (void)buttonClick:(UIButton *)sender
{
    if(sender.tag == 2)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(locationPickerView:didSelectedLocation:locationID:)])
        {
            [self.delegate locationPickerView:self didSelectedLocation:[NSString stringWithFormat:@"%@",self.model] locationID:self.locationID];
        }
    }
    [self hide];
}
#pragma mark - setter
- (UIView *)bgBlackView
{
    if(_bgBlackView == nil)
    {
        UIView *blackBgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        blackBgView.alpha = 0.0f;
        blackBgView.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [blackBgView addGestureRecognizer:tap];
        
        _bgBlackView = blackBgView;
    }
    return _bgBlackView;
}
- (UIPickerView *)pickerView
{
    if(_pickerView == nil)
    {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_BUTTON+(HEIGHT-HEIGHT_BUTTON-35)/2, WIDTH, 35)];
        bgView.backgroundColor = [UIColor redColor];
        [self addSubview:bgView];
        
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.frame = CGRectMake(0, HEIGHT_BUTTON, WIDTH, HEIGHT-HEIGHT_BUTTON);
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.backgroundColor = [UIColor clearColor];
        pickerView.showsSelectionIndicator = YES;
        [self clearSeparatorWithView:pickerView];
        _pickerView = pickerView;
    }
    return _pickerView;
}
- (NSArray *)provinceArray
{
    if(_provinceArray == nil)
    {
        if(self.level >= YYLocationPickerViewLevelProvince)
        {
            _provinceArray = [[YYLocationDataBase sharedDataBase] selectValueWithPid:@"0"];
            self.model.province = ((YYLocationDataBaseModel *)_provinceArray[0]).title;
            self.locationID = ((YYLocationDataBaseModel *)_provinceArray[0]).ID;
        }
    }
    return _provinceArray;
}
- (NSArray *)cityArray
{
    if(_cityArray == nil)
    {
        if(self.level >= YYLocationPickerViewLevelCity)
        {
            YYLocationDataBaseModel *model = self.provinceArray[0];
            _cityArray = [[YYLocationDataBase sharedDataBase] selectValueWithPid:model.ID];
            
            self.model.city = ((YYLocationDataBaseModel *)_cityArray[0]).title;
            self.locationID = ((YYLocationDataBaseModel *)_cityArray[0]).ID;
        }
    }
    return _cityArray;
}
- (YYLocationPickerViewLevel)level
{
    if(!_level)
    {
        _level = YYLocationPickerViewLevelProvince;
    }
    return _level;
}
- (NSArray *)areaArray
{
    if(_areaArray == nil)
    {
        if(self.level == YYLocationPickerViewLevelArea)
        {
            YYLocationDataBaseModel *model = self.cityArray[0];
            _areaArray = [[YYLocationDataBase sharedDataBase] selectValueWithPid:model.ID];
            
            if(_areaArray.count)
            {
                self.model.area = ((YYLocationDataBaseModel *)_areaArray[0]).title;
                self.locationID = ((YYLocationDataBaseModel *)_areaArray[0]).ID;
            }
            else
            {
                self.model.area = @"";
            }
        }
    }
    return _areaArray;
}
#pragma mark - 模型
- (YYLocationPickerViewModel *)model
{
    if(!_model)
    {
        _model = [[YYLocationPickerViewModel alloc] init];
    }
    return _model;
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.level;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return self.provinceArray.count;
            break;
        case 1:
            return self.cityArray.count;
            break;
        default:
            return self.areaArray.count;
            break;
    }
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return ((YYLocationDataBaseModel *)[self.provinceArray objectAtIndex:row]).title;
            break;
        case 1:
            return ((YYLocationDataBaseModel *)[self.cityArray objectAtIndex:row]).title;
            break;
        default:
            return ((YYLocationDataBaseModel *)[self.areaArray objectAtIndex:row]).title;
            break;
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 5.0;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        pickerLabel.minimumFontSize = 8.0;
#pragma clang diagnostic pop
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(self.level == YYLocationPickerViewLevelProvince)
    {
        self.model.province = ((YYLocationDataBaseModel *)self.provinceArray[row]).title;
        self.locationID = ((YYLocationDataBaseModel *)self.provinceArray[row]).ID;
    }
    else if(self.level == YYLocationPickerViewLevelCity)
    {
        switch (component)
        {
            case 0:
            {
                YYLocationDataBaseModel *model = self.provinceArray[row];
                self.cityArray = [[YYLocationDataBase sharedDataBase] selectValueWithPid:model.ID];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                
                self.model.province = ((YYLocationDataBaseModel *)self.provinceArray[row]).title;
                self.model.city = ((YYLocationDataBaseModel *)self.cityArray[0]).title;
                self.locationID = ((YYLocationDataBaseModel *)self.cityArray[0]).ID;
                break;
            }
            case 1:
            {
                
                self.model.city = ((YYLocationDataBaseModel *)self.cityArray[row]).title;
                self.locationID = ((YYLocationDataBaseModel *)self.cityArray[row]).ID;
                break;
            }
            default:
                break;
        }
    }
    else
    {
        switch (component)
        {
            case 0:
            {
                YYLocationDataBaseModel *model = self.provinceArray[row];
                self.cityArray = [[YYLocationDataBase sharedDataBase] selectValueWithPid:model.ID];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                
                
                YYLocationDataBaseModel *cityModel = self.cityArray[0];
                self.areaArray = [[YYLocationDataBase sharedDataBase] selectValueWithPid:cityModel.ID];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                
                
                self.model.province = ((YYLocationDataBaseModel *)self.provinceArray[row]).title;
                self.model.city = ((YYLocationDataBaseModel *)self.cityArray[0]).title;
                self.locationID = ((YYLocationDataBaseModel *)self.cityArray[0]).ID;
                if(self.areaArray.count)
                {
                    self.model.area = ((YYLocationDataBaseModel *)self.areaArray[0]).title;
                    self.locationID = ((YYLocationDataBaseModel *)self.areaArray[0]).ID;
                }
                else
                {
                    self.model.area = @"";
                }
                break;
            }
            case 1:
            {
                
                YYLocationDataBaseModel *cityModel = self.cityArray[row];
                self.areaArray = [[YYLocationDataBase sharedDataBase] selectValueWithPid:cityModel.ID];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                
                
                self.model.city = ((YYLocationDataBaseModel *)self.cityArray[row]).title;
                self.locationID = ((YYLocationDataBaseModel *)self.cityArray[row]).ID;
                if(self.areaArray.count)
                {
                    self.model.area = ((YYLocationDataBaseModel *)self.areaArray[0]).title;
                    self.locationID = ((YYLocationDataBaseModel *)self.areaArray[0]).ID;
                }
                else
                {
                    self.model.area = @"";
                }
                break;
            }
            default:
            {
                if(self.areaArray.count)
                {
                    self.model.area = ((YYLocationDataBaseModel *)self.areaArray[row]).title;
                    self.locationID = ((YYLocationDataBaseModel *)self.areaArray[row]).ID;
                }
                else
                {
                    self.model.area = @"";
                }
                break;
            }
        }
    }
}
#pragma mark - function
- (void)clearSeparatorWithView:(UIView * )view
{
    if(view.subviews != 0)
    {
        if(view.bounds.size.height < 5)
        {
            view.backgroundColor = [UIColor clearColor];
        }
        
        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
            [self clearSeparatorWithView:obj];
        }];
    }
    
}
- (void)show
{
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        
        self.bgBlackView.alpha = 0.5f;
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-HEIGHT, WIDTH, HEIGHT);
    }];
}
- (void)hide
{
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        
        self.bgBlackView.alpha = 0.0f;
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, WIDTH, HEIGHT);
        
    } completion:^(BOOL finished) {
        [self.bgBlackView removeFromSuperview];
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
    
}

@end


@implementation YYLocationPickerViewModel


- (NSString *)description
{
    if(self.city.length)
    {
        if(self.area.length)
        {
            return [NSString stringWithFormat:@"%@-%@-%@",self.province,self.city,self.area];
        }
        else
        {
            return [NSString stringWithFormat:@"%@-%@",self.province,self.city];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%@",self.province];
    }
}

@end
