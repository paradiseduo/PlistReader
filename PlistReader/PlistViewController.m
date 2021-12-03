//
//  PlistViewController.m
//  yacd
//
//  Created by Paradiseduo on 2021/6/29.
//  Copyright © 2021 Selander. All rights reserved.
//

#import "PlistViewController.h"
#import "Masonry/Masonry.h"

@interface PlistViewController ()
@property (nonatomic, strong) UITextView * text;
@end

@implementation PlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setModel:(Model *)model {
    UITextView * text = [[UITextView alloc] init];
    text.editable = NO;
    [self.view addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    self.text = text;
    self.text.text = model.plist;
    self.navigationItem.title = model.name;
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
