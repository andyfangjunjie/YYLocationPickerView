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
