# JJPicker
用法:<br>
展示时间picker界面<br>
`
picker = [[JJPicker alloc] initDatePickerWithTitle:@"标题" showType:JJPickerShowTypeBottom completion:^(id data) {处理数据}];
`<br>
展示自定义picker界面<br>
`
picker = [[JJPicker alloc] initCustomPickerWithTitle:@"标题" showType:JJPickerShowTypeCenter reload:^(NSInteger index, id tag) {刷新某一层数据} completion:^(id data) {处理数据}];
`<br>
`
[picker setUpItems:house];
`<br>
刷新某一层数据的用法<br>
`
[self->picker reloadComponent:index itmes:minute];
`
