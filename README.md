OXSwitch
继承与UIControl 类似UISwitch的一个控件
用block回调 
_oxSwitch = [[OXSwitch alloc]initWithFrame:CGRectMake(50, 50, 40, 25)];
self.oxSwitch.status = SwitchStatuOff;
[self.oxSwitch handleWithBlock:UIControlEventTouchUpInside blcok:^(BOOL status) {
NSLog(@"status = %d",status);
}];
![image](https://github.com/h5865885/OXSwitch/blob/master/switch.gif)   
