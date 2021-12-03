//
//  Model.h
//  PlistReader
//
//  Created by Paradiseduo on 2021/12/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * bundleID;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, copy) NSString * plistPath;
@property (nonatomic, copy) NSString * plist;
@property (nonatomic) BOOL hasIt;
@end

NS_ASSUME_NONNULL_END
