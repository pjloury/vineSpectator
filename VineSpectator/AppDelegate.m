//
//  AppDelegate.m
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "VSTableViewController.h"
#import "VSBottle.h"
#import "VSGrapeVariety.h"
#import "VSVineyard.h"

// the user should be cached
// rely on the local cache, THEN attempt to fetch from the network.

// 1: Implement Login
// 2: Implement "No Bottles"
// 3: Implement "Edit Custom Tags". Red and White should always be present
// 4: Move Chrono Sort to the Nav Bar (as a sort toggle, not a filter)
// 5: Remove Search
// BONUS: If Grape Variety matches a known Grape variety, auto populate the "Red/White" field

// How to add images to the camera roll
// T2: Welcome back, david
// T3: Tap on the next field and it will jump to complete the word
// Mock up some bottles!

// P1: After you add a Bottle, you should be able to see it in your list!

// No intuitive way to dismiss number keyboard
// Add drank feature to tableview
// Rely on cache, then hit the network
// Downsize Kaiti and Yu Mincho fonts
// Sort Bottles by Date
// Add Back button back
// Scrolls to support text views
// Support 

@interface AppDelegate ()

// Lucida Grande
// Kaiti SC
// Avenir
// Athelas-Regular
// Avenir-Book
// Baskerville (do not specify regular!)
// BodoniSvtyTwoITCTT-Book
// STKaiti-SC-Regular
// LucidaGrande
// YuMin-Demibold
// YuMin-Medium

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [PFUser enableAutomaticUser];
    [Parse enableLocalDatastore];
   
    // Initialize Parse.
    [Parse setApplicationId:@"DtRXJrCQggcg4o1L1t34CMpPS5tFwe4Crc88Y0hE"
                  clientKey:@"HuXWIX37b4gonGqBKdK6EKdrlTR4BYjCQkVh15aF"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /*
    if (![PFUser currentUser]) {
        PFLogInViewController *loginController = [[PFLogInViewController alloc] init];
        loginController.fields = (PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton |
        PFLogInFieldsPasswordForgotten);
        loginController.view.backgroundColor = [UIColor offWhiteColor];
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:loginController];
        nc.navigationBar.translucent = NO;
        [[UINavigationBar appearance] setBarTintColor:[UIColor wineColor]];
        loginController.logInView.logInButton.backgroundColor = [UIColor wineColor];
        [loginController.logInView.logInButton setBackgroundImage:nil
                                                          forState:UIControlStateNormal];
        [loginController.logInView.signUpButton setBackgroundImage:nil
                                                              forState:UIControlStateNormal];
        loginController.logInView.logInButton.backgroundColor = [UIColor wineColor];
        loginController.logInView.signUpButton.backgroundColor = [UIColor oliveInkColor];
        
        self.window.rootViewController = nc;
    }
    else {
        VSTableViewController *tv = [[VSTableViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tv];
        [[UINavigationBar appearance] setBarTintColor:[UIColor wineColor]];
        self.window.rootViewController = nc;
    }
    */

    VSTableViewController *tv = [[VSTableViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tv];
    [[UINavigationBar appearance] setBarTintColor:[UIColor wineColor]];
    self.window.rootViewController = nc;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Core Data stack

//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//
//- (NSURL *)applicationDocumentsDirectory {
//    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.pjloury.VineSpectator" in the application's documents directory.
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
//
//- (NSManagedObjectModel *)managedObjectModel {
//    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"VineSpectator" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
//    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    // Create the coordinator and store
//    
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"VineSpectator.sqlite"];
//    NSError *error = nil;
//    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        // Report any error we got.
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//        dict[NSUnderlyingErrorKey] = error;
//        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//        // Replace this with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
//}
//
//
//- (NSManagedObjectContext *)managedObjectContext {
//    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (!coordinator) {
//        return nil;
//    }
//    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    return _managedObjectContext;
//}
//
//#pragma mark - Core Data Saving support
//
//- (void)saveContext {
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        NSError *error = nil;
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}

@end
