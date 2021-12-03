//
//  AppDelegate.m
//  PlistReader
//
//  Created by Paradiseduo on 2021/12/1.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    UINavigationController * nv = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    self.window.rootViewController = nv;
    [self.window makeKeyAndVisible];
    return YES;
}



@end
