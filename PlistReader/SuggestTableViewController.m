//
//  SuggestTableViewController.m
//  PlistReader
//
//  Created by Paradiseduo on 2021/12/2.
//

#import "SuggestTableViewController.h"
#import "Masonry/Masonry.h"

@interface SuggestTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray * dataArray;
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation SuggestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Search Suggest";
    
    UITableView * table = [[UITableView alloc] init];
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    table.delegate = self;
    table.dataSource = self;
    self.tableView = table;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SuggestCell"];
    _dataArray = [[NSArray alloc] initWithObjects:
                  @"NSBluetoothAlwaysUsageDescription",
                  @"NSBluetoothPeripheralUsageDescription",
                  @"NSCalendarsUsageDescription",
                  @"NSRemindersUsageDescription",
                  @"NSCameraUsageDescription",
                  @"NSMicrophoneUsageDescription",
                  @"NSContactsUsageDescription",
                  @"NSFaceIDUsageDescription",
                  @"NSDesktopFolderUsageDescription",
                  @"NSDocumentsFolderUsageDescription",
                  @"NSDownloadsFolderUsageDescription",
                  @"NSNetworkVolumesUsageDescription",
                  @"NSRemovableVolumesUsageDescription",
                  @"NSFileProviderPresenceUsageDescription",
                  @"NSFileProviderDomainUsageDescription",
                  @"NSHealthClinicalHealthRecordsShareUsageDescription",
                  @"NSHealthShareUsageDescription",
                  @"NSHealthUpdateUsageDescription",
                  @"NSHomeKitUsageDescription",
                  @"NSLocationAlwaysAndWhenInUseUsageDescription",
                  @"NSLocationUsageDescription",
                  @"NSLocationWhenInUseUsageDescription",
                  @"NSLocationAlwaysUsageDescription",
                  @"NSAppleMusicUsageDescription",
                  @"NSMotionUsageDescription",
                  @"NSLocalNetworkUsageDescription",
                  @"NFCReaderUsageDescription",
                  @"NSPhotoLibraryAddUsageDescription",
                  @"NSPhotoLibraryUsageDescription",
                  @"NSUserTrackingUsageDescription",
                  @"NSAppleEventsUsageDescription",
                  @"NSSystemAdministrationUsageDescription",
                  @"NSSiriUsageDescription",
                  @"NSSpeechRecognitionUsageDescription",
                  @"NSVideoSubscriberAccountUsageDescription", nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuggestCell" forIndexPath:indexPath];
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _dataArray[indexPath.row];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Copy Success" message:pasteboard.string  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Back" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
