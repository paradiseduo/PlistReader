//
//  UserDefaultViewController.m
//  PlistReader
//
//  Created by admin on 2022/6/23.
//

#import "UserDefaultViewController.h"
#import "Masonry/Masonry.h"
#import "NSObject+PrettyPrinted.h"

@interface UserDefaultViewController ()
@property (nonatomic, strong) UITextView * text;
@end

@implementation UserDefaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setModel:(FileModel *)model {
    UITextView * text = [[UITextView alloc] init];
    text.editable = NO;
    [self.view addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    self.text = text;
    NSError * err = nil;
    NSString * pp = [NSString stringWithContentsOfFile:model.path encoding:NSUTF8StringEncoding error:&err];
    if (err != nil) {
        NSString * p = [[NSDictionary dictionaryWithContentsOfFile:model.path] pretty];
        if (p.length > 0) {
            self.text.text = p;
        } else {
            self.text.text = [NSString stringWithFormat:@"%@", [NSDictionary dictionaryWithContentsOfFile:model.path]];
        }
    } else {
        self.text.text = pp;
    }
    self.navigationItem.title = model.name;
}

@end
