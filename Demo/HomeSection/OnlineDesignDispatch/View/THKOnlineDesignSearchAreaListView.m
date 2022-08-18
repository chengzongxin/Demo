//
//  THKOnlineDesignSearchAreaListView.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import "THKOnlineDesignSearchAreaListView.h"
#import "THKOnlineDesignSearchAreaListCell.h"
@interface THKOnlineDesignSearchAreaListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THKOnlineDesignSearchAreaListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitalilze];
    }
    return self;
}

- (void)didInitalilze{
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setItems:(NSArray<THKOnlineDesignAreaListDataItem *> *)items{
    _items = items;
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THKOnlineDesignSearchAreaListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(THKOnlineDesignSearchAreaListCell.class) forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.keyWord = self.keyWord;
    cell.model = self.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tapItem) {
        self.tapItem(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:THKOnlineDesignSearchAreaListCell.class forCellReuseIdentifier:NSStringFromClass(THKOnlineDesignSearchAreaListCell.class)];
    }
    return _tableView;
}



@end
