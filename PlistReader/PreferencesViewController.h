//
//  PreferencesViewController.h
//  PlistReader
//
//  Created by admin on 2022/6/23.
//

#import <UIKit/UIKit.h>
#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface PreferencesViewController : UIViewController
@property (nonatomic, copy) NSMutableArray<FileModel *> * files;
@end

NS_ASSUME_NONNULL_END
