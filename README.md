# YYLocationPickerView
一个简单实用的城市选择器多级联动，可选择

##创建
```objc
YYLocationPickerView *location = [[YYLocationPickerView alloc] initWithLevel:YYLocationPickerViewLevelProvince andDelegate:self];
[location show];
```
##返回数据代理
```objc
<YYLocationPickerViewDelegate>
- (void)locationPickerView:(YYLocationPickerView *)locationPickerView didSelectedLocation:(NSString *)location locationID:(NSString *)locationID
{
    NSLog(@"%@ - %@",location,locationID);
}
```

##一级实例
![image](https://github.com/andyfangjunjie/YYLocationPickerView/raw/master/Resources/一级.png)
##二级实例
![image](https://github.com/andyfangjunjie/YYLocationPickerView/raw/master/Resources/二级.png)
##三级实例
![image](https://github.com/andyfangjunjie/YYLocationPickerView/raw/master/Resources/三级.png)
