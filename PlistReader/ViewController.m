//
//  ViewController.m
//  PlistReader
//
//  Created by Paradiseduo on 2021/12/1.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "PlistViewController.h"
#import "Masonry/Masonry.h"
#import "SuggestTableViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * table;
@property (nonatomic) BOOL showed;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showed = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView * table = [[UITableView alloc] init];
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    table.delegate = self;
    table.dataSource = self;
    self.table = table;
    
    self.navigationItem.title = @"PlistReader";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(suggest)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.table reloadData];
}

- (void)setPlistArray:(NSMutableArray<Model *> *)plistArray {
    _plistArray = [[NSMutableArray alloc] initWithArray:plistArray];
}

- (void)reloadWithSearch:(NSString *)item {
    for (Model * model in _plistArray) {
        model.hasIt = [model.plist containsString:item];
    }
    [self.table reloadData];
}

- (void)suggest {
    if (!self.showed) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Search Key Word" message:@"You can see the search suggestions here, tap it to copy" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Get search Suggest" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.showed = YES;
            [self.navigationController pushViewController:[[SuggestTableViewController alloc] init] animated:YES];
        }]];
        [self presentViewController:alertController animated:true completion:nil];
    } else {
        [self.navigationController pushViewController:[[SuggestTableViewController alloc] init] animated:YES];
    }
}

- (void)search {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Search" message:@"Enter what needs to be searched in the plist file" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Canel" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Enter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        UITextField *titleTextField = alertController.textFields.firstObject;
        [self reloadWithSearch:titleTextField.text];
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"search plist";
        if ([[UIPasteboard generalPasteboard].string length] > 0) {
            textField.text = [UIPasteboard generalPasteboard].string;
        }
    }];
    [self presentViewController:alertController animated:true completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TableViewCell * cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellMe"];
    [cell setModel:_plistArray[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _plistArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PlistViewController * vv = [[PlistViewController alloc] init];
    [vv setModel:_plistArray[indexPath.row]];
    [self.navigationController pushViewController:vv animated:YES];
}


@end
