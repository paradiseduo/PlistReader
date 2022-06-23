//
//  AppDelegate.m
//  PlistReader
//
//  Created by Paradiseduo on 2021/12/1.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "ViewController.h"
#import "CoreServices.h"
#import "Model.h"
#import "NSObject+PrettyPrinted.h"

__attribute__((weak))
extern CGImageRef LICreateIconFromCachedBitmap(NSData* data);

@interface AppDelegate ()
@property (nonatomic, copy) NSMutableArray<Model *>* users;
@property (nonatomic, copy) NSMutableArray<Model *>* systems;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [self prepareData];
    
    ViewController * v1 = [[ViewController alloc] init];
    v1.tabBarItem.title = @"Users";
    v1.tabBarItem.image = [UIImage imageNamed:@"U"];
    v1.plistArray = _users;
    
    ViewController * v2 = [[ViewController alloc] init];
    v2.tabBarItem.title = @"System";
    v2.tabBarItem.image = [UIImage imageNamed:@"S"];
    v2.plistArray = _systems;
    
    UITabBarController * tab = [[UITabBarController alloc] init];
    tab.viewControllers = @[[[BaseNavigationController alloc] initWithRootViewController:v1], [[BaseNavigationController alloc] initWithRootViewController:v2]];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)prepareData {
    _users = [[NSMutableArray alloc] init];
    _systems = [[NSMutableArray alloc] init];
    
    id<LSApplicationWorkspaceProtocol> LSApplicationWorkspace = (id<LSApplicationWorkspaceProtocol>)NSClassFromString(@"LSApplicationWorkspace");
    NSArray<id<LSApplicationProxyProtocol>>* installedApplications = [[LSApplicationWorkspace defaultWorkspace] allApplications];

    for (int i = 0 ; i < installedApplications.count; ++i) {
        id application = installedApplications[i];
        
        NSData *data = [application primaryIconDataForVariant:0x20];
        CGImageRef imageRef = LICreateIconFromCachedBitmap(data);
        CGFloat scale = [UIScreen mainScreen].scale;

        id path = [application canonicalExecutablePath];
        NSArray * arr = [path componentsSeparatedByString:@"/"];
        NSMutableString * s = [[NSMutableString alloc] init];
        for (int i = 1; i < arr.count-1; ++i) {
            [s appendFormat:@"/%@", arr[i]];
        }

        Model * model = [[Model alloc] init];
        model.name = [application localizedName];
        model.bundleID = [application bundleIdentifier];
        model.image = [[UIImage alloc] initWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
        model.plistPath = [NSString stringWithFormat:@"%@/Info.plist", s];
        NSError * err = nil;
        NSString * pp = [NSString stringWithContentsOfFile:model.plistPath encoding:NSUTF8StringEncoding error:&err];
        if (err != nil) {
            NSString * p = [[NSDictionary dictionaryWithContentsOfFile:model.plistPath] pretty];
            if (p.length > 0) {
                model.plist = p;
            } else {
                model.plist = [NSString stringWithFormat:@"%@", [NSDictionary dictionaryWithContentsOfFile:model.plistPath]];
            }
        } else {
            model.plist = pp;
        }
        model.containerPath = [[application containerURL] path];
        model.hasIt = NO;
        
        if ([[application bundleIdentifier] containsString:@"com.apple"]) {
            [_systems addObject:model];
        } else {
            [_users addObject:model];
        }
    }
}

@end
