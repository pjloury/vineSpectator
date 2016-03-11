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

// Implement Login. Why? People want their photos no matter what
// Default Red and White Tags.
// Decide how to express Grape Color
// Implement "No Bottles"
// "Drank" should show up in Detail View Controller
// Tap Top of Nav Bar to Scroll to Top
// Share and Logout Buttons
// Footer View 5 Bottles

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
    */
    //else {
        VSTableViewController *tv = [[VSTableViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tv];
        [[UINavigationBar appearance] setBarTintColor:[UIColor wineColor]];
        self.window.rootViewController = nc;
    // }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //
}

@end
