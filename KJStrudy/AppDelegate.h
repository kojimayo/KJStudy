//
//  AppDelegate.h
//  KJStrudy
//
//  Created by 小島 佳幸 on 2016/04/10.
//  Copyright © 2016年 小島 佳幸. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LGSideMenuController.h"

#define kMainViewController                            (LGSideMenuController *)[UIApplication sharedApplication].delegate.window.rootViewController
#define kNavigationController (UINavigationController *)[(LGSideMenuController *)[UIApplication sharedApplication].delegate.window.rootViewController rootViewController]


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

