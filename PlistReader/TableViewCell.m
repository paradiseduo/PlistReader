//
//  TableViewCell.m
//  PlistReader
//
//  Created by Paradiseduo on 2021/12/2.
//

#import "TableViewCell.h"
#import "Masonry/Masonry.h"

@interface TableViewCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *status;
@property (nonatomic, strong) UILabel *bundleID;
@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *icon = [[UIImageView alloc] init];
        icon.layer.cornerRadius = 4;
        icon.layer.masksToBounds = YES;
        [self.contentView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@50);
            make.left.equalTo(self.contentView.mas_left).with.inset(16);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        self.icon = icon;
        
        UILabel *status = [[UILabel alloc] init];
        status.backgroundColor = [UIColor redColor];
        status.layer.cornerRadius = 5;
        status.layer.masksToBounds = YES;
        [self.contentView addSubview:status];
        [status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.inset(20);
            make.height.width.equalTo(@10);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        self.status = status;
        
        UILabel *name = [[UILabel alloc] init];
        name.numberOfLines = 1;
        name.font = [UIFont boldSystemFontOfSize:20.f];
        [self.contentView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).with.inset(10);
            make.top.equalTo(icon.mas_top);
            make.right.equalTo(status.mas_left);
        }];
        self.name = name;
        
        UILabel *bundleID = [[UILabel alloc] init];
        bundleID.numberOfLines = 1;
        bundleID.font = [UIFont systemFontOfSize:16.f];
        [self.contentView addSubview:bundleID];
        [bundleID mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).with.inset(10);
            make.bottom.equalTo(icon.mas_bottom);
            make.right.equalTo(status.mas_left);
        }];
        self.bundleID = bundleID;
    }
    
    return self;
}

- (void)setModel:(Model *)model {
    self.name.text = model.name;
    self.icon.image = model.image;
    self.bundleID.text = model.bundleID;
    [self.status setHidden:!model.hasIt];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
