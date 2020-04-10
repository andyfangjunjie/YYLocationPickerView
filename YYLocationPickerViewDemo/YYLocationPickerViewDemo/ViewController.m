//
//  ViewController.m
//  YYLocationPickerViewDemo
//
//  Created by 房俊杰 on 2017/2/26.
//  Copyright © 2017年 上海涵予信息科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "YYLocation.h"



@interface ViewController ()<UITextFieldDelegate,YYLocationPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *provinceTextField;

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;

@property (weak, nonatomic) IBOutlet UITextField *areaTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    
    
    
    
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];

    if(textField == self.provinceTextField)
    {
        YYLocationPickerView *location = [[YYLocationPickerView alloc] initWithLevel:YYLocationPickerViewLevelProvince andDelegate:self];
        location.tag = 1;
        [location show];
    }
    if(textField == self.cityTextField)
    {
        YYLocationPickerView *location = [[YYLocationPickerView alloc] initWithLevel:YYLocationPickerViewLevelCity andDelegate:self];
        location.tag = 2;
        [location show];
    }
    if(textField == self.areaTextField)
    {
        YYLocationPickerView *location = [[YYLocationPickerView alloc] initWithLevel:YYLocationPickerViewLevelArea andDelegate:self];
        location.tag = 3;
        [location show];
    }
}

#pragma mark - YYLocationPickViewDelegate
- (void)locationPickerView:(YYLocationPickerView *)locationPickerView didSelectedLocation:(NSString *)location locationID:(NSString *)locationID
{
    switch (locationPickerView.tag) {
        case 1:
        {
            self.provinceTextField.text = [NSString stringWithFormat:@"%@-%@",location,locationID];
            break;
        }
        case 2:
        {
            self.cityTextField.text = [NSString stringWithFormat:@"%@-%@",location,locationID];
            break;
        }
        case 3:
        {
            self.areaTextField.text = [NSString stringWithFormat:@"%@-%@",location,locationID];
            break;
        }
        default:
            break;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

@end
