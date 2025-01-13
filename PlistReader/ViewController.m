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
#import <dlfcn.h>

@interface SKUIItemStateCenter : NSObject
+ (id)defaultCenter;
- (id)_newPurchasesWithItems:(id)items;
- (void)_performPurchases:(id)purchases hasBundlePurchase:(_Bool)purchase withClientContext:(id)context completionBlock:(id /* block */)block;
- (void)_performSoftwarePurchases:(id)purchases withClientContext:(id)context completionBlock:(id /* block */)block;
@end

@interface SKUIItem : NSObject
- (id)initWithLookupDictionary:(id)dictionary;
@end

@interface SKUIItemOffer : NSObject
- (id)initWithLookupDictionary:(id)dictionary;
@end

@interface SKUIClientContext : NSObject
+ (id)defaultContext;
@end

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * table;
@property (nonatomic) BOOL showed;
@end

@implementation ViewController
+ (void)load {
    char *error;
    void *handle = dlopen("/System/Library/PrivateFrameworks/StoreKitUI.framework/StoreKitUI", RTLD_NOW);
    if (handle == NULL) {
       error = dlerror();
       NSLog(@"dlopen error: %s", error);
    }else {
       NSLog(@"dlopen load /System/Library/PrivateFrameworks/StoreKitUI.framework/StoreKitUI success.");
    }
    void *handle2 = dlopen("/System/Library/PrivateFrameworks/Preferences.framework/Preferences", RTLD_NOW);
    if (handle2 == NULL) {
       error = dlerror();
       NSLog(@"dlopen error: %s", error);
    }else {
       NSLog(@"dlopen load /System/Library/PrivateFrameworks/Preferences.framework/Preferences success.");
    }
}

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
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }] resume];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction * download = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"历史版本" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self downloadAppShortcut:self->_plistArray[indexPath.row].bundleID];
    }];
    return @[download];
}

- (void)downloadAppShortcut:(NSString *)bundleId {
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?bundleId=%@&limit=1&media=software", bundleId]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert:@"Error" message:error.localizedDescription];
            });
            return;
        }
        NSError* jsonError = nil;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if(jsonError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert:@"JSON Error" message:jsonError.localizedDescription];
            });
            return;
        }
        NSArray* results = json[@"results"];
        if(results.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert:@"Error" message:@"No results"];
            });
            return;
        }
        NSDictionary* app = results[0];
        [self getAllAppVersionIdsAndPrompt:[app[@"trackId"] longLongValue]];
    }] resume];
}

- (void)getAllAppVersionIdsAndPrompt:(long long)appId {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* promptAlert = [UIAlertController alertControllerWithTitle:@"Version ID" message:@"Do you want to enter the version ID manually or request the list of version IDs from the server?" preferredStyle:UIAlertControllerStyleAlert];
        [promptAlert addAction:[UIAlertAction actionWithTitle:@"Manual" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
            [self promptForVersionId:appId];
        }]];
        [promptAlert addAction:[UIAlertAction actionWithTitle:@"Server" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
            [self getAllAppVersionIdsFromServer:appId];
        }]];
        [promptAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:promptAlert animated:YES completion:nil];
    });
}

- (void)promptForVersionId:(long long)appId {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* versionAlert = [UIAlertController alertControllerWithTitle:@"Version ID" message:@"Enter the version ID of the app you want to download" preferredStyle:UIAlertControllerStyleAlert];
        [versionAlert addTextFieldWithConfigurationHandler:^(UITextField* textField) {
            textField.placeholder = @"Version ID";
        }];
        UIAlertAction* downloadAction = [UIAlertAction actionWithTitle:@"Download" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
            long long versionId = [versionAlert.textFields.firstObject.text longLongValue];
            [self downloadAppWithAppId:appId versionId:versionId];
        }];
        [versionAlert addAction:downloadAction];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [versionAlert addAction:cancelAction];
        [self presentViewController:versionAlert animated:YES completion:nil];
    });
}

- (void)downloadAppWithAppId:(long long)appId versionId:(long long)versionId {
    NSString* adamId = [NSString stringWithFormat:@"%lld", appId];
    NSString* pricingParameters = @"pricingParameter";
    NSString* appExtVrsId = [NSString stringWithFormat:@"%lld", versionId];
    NSString* installed = @"0";
    NSString* offerString = nil;
    if (versionId == 0) {
        offerString = [NSString stringWithFormat:@"productType=C&price=0&salableAdamId=%@&pricingParameters=%@&clientBuyId=1&installed=%@&trolled=1", adamId, pricingParameters, installed];
    } else {
        offerString = [NSString stringWithFormat:@"productType=C&price=0&salableAdamId=%@&pricingParameters=%@&appExtVrsId=%@&clientBuyId=1&installed=%@&trolled=1", adamId, pricingParameters, appExtVrsId, installed];
    }
    NSDictionary* offerDict = @{@"buyParams": offerString};
    NSDictionary* itemDict = @{@"_itemOffer": adamId};
    
    id offer = [[NSClassFromString(@"SKUIItemOffer") performSelector:NSSelectorFromString(@"alloc")] performSelector:NSSelectorFromString(@"initWithLookupDictionary:") withObject:offerDict];
    id item = [[NSClassFromString(@"SKUIItem") performSelector:NSSelectorFromString(@"alloc")] performSelector:NSSelectorFromString(@"initWithLookupDictionary:") withObject:itemDict];
    [item setValue:offer forKey:@"_itemOffer"];
    [item setValue:@"iosSoftware" forKey:@"_itemKindString"];
    if(versionId != 0) {
        [item setValue:@(versionId) forKey:@"_versionIdentifier"];
    }
    id center = [NSClassFromString(@"SKUIItemStateCenter") performSelector:NSSelectorFromString(@"defaultCenter")];
    NSArray* items = @[item];
    dispatch_async(dispatch_get_main_queue(), ^{
        [center _performPurchases:[center _newPurchasesWithItems:items] hasBundlePurchase:0 withClientContext:[NSClassFromString(@"SKUIClientContext") performSelector:NSSelectorFromString(@"defaultContext")] completionBlock:^(id arg1){
            NSLog(@"%@", arg1);
        }];
    });
}

- (void)getAllAppVersionIdsFromServer:(long long)appId {
    NSString* serverURL = @"https://apis.bilin.eu.org/history/";
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%lld", serverURL, appId]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
        if(error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert:@"Error" message:error.localizedDescription];
            });
            return;
        }
        NSError* jsonError = nil;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if(jsonError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert:@"JSON Error" message:jsonError.debugDescription];
            });
            return;
        }
        NSArray* versionIds = json[@"data"];
        if(versionIds.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlert:@"Error" message:@"No version IDs, internal error maybe?"];
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController* versionAlert = [UIAlertController alertControllerWithTitle:@"Version ID" message:@"Select the version ID of the app you want to download" preferredStyle:UIAlertControllerStyleAlert];
            for(NSDictionary* versionId in versionIds) {
                UIAlertAction* versionAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", versionId[@"bundle_version"]] style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
                    [self downloadAppWithAppId:appId versionId:[versionId[@"external_identifier"] longLongValue]];
                }];
                [versionAlert addAction:versionAction];
            }
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [versionAlert addAction:cancelAction];
            [self presentViewController:versionAlert animated:YES completion:nil];
        });
    }];
    [task resume];
}

- (void)showAlert:(NSString*)title message:(NSString*)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}
@end
