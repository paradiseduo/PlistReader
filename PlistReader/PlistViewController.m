//
//  PlistViewController.m
//  yacd
//
//  Created by Paradiseduo on 2021/6/29.
//  Copyright © 2021 Selander. All rights reserved.
//

#import "PlistViewController.h"
#import "Masonry/Masonry.h"
#import "PreferencesViewController.h"

@interface PlistViewController ()
@property (nonatomic, strong) UITextView * text;
@property (nonatomic, copy) NSMutableArray<FileModel *> * filePaths;
@end

@implementation PlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(userdefault)];
}

- (void)setModel:(Model *)model {
    UITextView * text = [[UITextView alloc] init];
    text.editable = NO;
    [self.view addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    self.text = text;
    self.text.text = [NSString stringWithFormat:@"%@", model.plist];
    self.navigationItem.title = model.name;
    
    _filePaths = [[NSMutableArray alloc] init];
    NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Library/Preferences", model.containerPath] error:nil];
    for (NSString * p in files) {
        FileModel * m = [[FileModel alloc] init];
        m.name = p;
        m.path = [NSString stringWithFormat:@"%@/Library/Preferences/%@", model.containerPath, p];
        [_filePaths addObject:m];
    }
}

- (void)userdefault {
    PreferencesViewController * v = [[PreferencesViewController alloc] init];
    v.files = _filePaths;
    [self.navigationController pushViewController:v animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
