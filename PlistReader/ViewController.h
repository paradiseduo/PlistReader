//
//  ViewController.h
//  PlistReader
//
//  Created by Paradiseduo on 2021/12/1.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface ViewController : UIViewController
@property (nonatomic, copy) NSMutableArray<Model *> * plistArray;
@end

@interface VersionViewController : UIViewController
@property (nonatomic, copy) NSString * bundleID;
@property (nonatomic, copy) NSString * nowVersion;
@end
