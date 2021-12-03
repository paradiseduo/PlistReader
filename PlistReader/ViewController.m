//
//  ViewController.m
//  PlistReader
//
//  Created by Paradiseduo on 2021/12/1.
//

#import "ViewController.h"
#import "CoreServices.h"
#import "TableViewCell.h"
#import "PlistViewController.h"
#import "Masonry/Masonry.h"
#import "Model.h"
#import "SuggestTableViewController.h"

__attribute__((weak))
extern CGImageRef LICreateIconFromCachedBitmap(NSData* data);

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * table;
@property (nonatomic, copy) NSMutableArray<Model *> * plistArray;
@property (nonatomic) BOOL showed;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _plistArray = [[NSMutableArray alloc] init];
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
    
    [self prepareData];
}

- (void)prepareData {
    id<LSApplicationWorkspaceProtocol> LSApplicationWorkspace = (id<LSApplicationWorkspaceProtocol>)NSClassFromString(@"LSApplicationWorkspace");
    NSArray<id<LSApplicationProxyProtocol>>* installedApplications = [[LSApplicationWorkspace defaultWorkspace] allApplications];
    
    for (int i = 0 ; i < installedApplications.count; ++i) {
        id application = installedApplications[i];
        if ([[application bundleIdentifier] containsString:@"com.apple"]) {
            continue;
        } else {
            NSData *data = [application primaryIconDataForVariant:0x20];
            CGImageRef imageRef = LICreateIconFromCachedBitmap(data);
            CGFloat scale = [UIScreen mainScreen].scale;
            
            id path = [application canonicalExecutablePath];
            NSArray * arr = [path componentsSeparatedByString:@"/"];
            NSMutableString * s = [[NSMutableString alloc] init];
            for (int i = 1; i < arr.count-1; ++i) {
                [s appendFormat:@"/%@", arr[i]];
            }
            
            Model * model = [[Model alloc] init];
            model.name = [application localizedName];
            model.bundleID = [application bundleIdentifier];
            model.image = [[UIImage alloc] initWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
            model.plistPath = [NSString stringWithFormat:@"%@/Info.plist", s];
            model.plist = [NSString stringWithFormat:@"%@", [[NSMutableDictionary alloc] initWithContentsOfFile:model.plistPath]];
            model.hasIt = NO;
            
            [_plistArray addObject:model];
        }
    }
    [self.table reloadData];
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
