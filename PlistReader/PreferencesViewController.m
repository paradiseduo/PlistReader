//
//  PreferencesViewController.m
//  PlistReader
//
//  Created by admin on 2022/6/23.
//

#import "PreferencesViewController.h"
#import "Masonry/Masonry.h"
#import "UserDefaultViewController.h"

@interface PreferencesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * table;
@end

@implementation PreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView * table = [[UITableView alloc] init];
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    table.delegate = self;
    table.dataSource = self;
    self.table = table;
    
    self.navigationItem.title = @"PreferencesPlistReader";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.table reloadData];
}

- (void)setFiles:(NSMutableArray<FileModel *> *)files {
    _files = [[NSMutableArray alloc] initWithArray:files];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_files count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIT"];
    cell.textLabel.text = _files[indexPath.row].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserDefaultViewController * c = [[UserDefaultViewController alloc] init];
    [c setModel:_files[indexPath.row]];
    [self.navigationController pushViewController:c animated:YES];
}

@end
