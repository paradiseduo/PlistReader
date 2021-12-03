//
//  TableViewCell.h
//  PlistReader
//
//  Created by Paradiseduo on 2021/12/2.
//

#import <UIKit/UIKit.h>
#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell
- (void)setModel:(Model *)model;
@end

NS_ASSUME_NONNULL_END
