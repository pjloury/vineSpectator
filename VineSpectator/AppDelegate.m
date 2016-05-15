//
//  AppDelegate.m
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "VSViewController.h"
#import "VSTableViewController.h"
#import "VSBottle.h"
#import "VSGrapeVariety.h"
#import "VSVineyard.h"

// Underline on section header
// Experiment with Sorting by Year within a given section
// Show # of bottles in a section if there are > 5
// Better Clock & Search Icons
// Search Query should clean up when collapsed
// Clean up Image Button in Detail for edit/non-edit
// Place color before tags for each bottle
// Empty State for tags
// Implement Discard Bottle
// Allow the addition of Black Muscat

// rely on the local cache, THEN attempt to fetch from the network.
// Tap Top of Nav Bar to Scroll to Top

// Collapsing Search Bar should clear all filters

// No intuitive way to dismiss number keyboard

@interface AppDelegate () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

// Lucida Grande
// Kaiti SC
// Avenir
// Athelas-Regular
// Avenir-Book
// Baskerville (do not specify regular!)
// BodoniSvtyTwoITCTT-Book
// Palatino-Regular
// LucidaGrande

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
    
    if (![PFUser currentUser]) {
        [self showLoginViewController];
    } else {
        [self showTableViewController];
    }

    [self.window makeKeyAndVisible];
    return YES;
}


- (void)showLoginViewController
{
     // Show the navBar with Vine Spectator too
     PFLogInViewController *loginController = [[PFLogInViewController alloc] init];
     // Should I allow Facebook login too?
     loginController.fields = (PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton |
     PFLogInFieldsPasswordForgotten);
     loginController.view.backgroundColor = [UIColor parchmentColor];
     loginController.logInView.logo = self.icon;
    
     UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:loginController];
     nc.navigationBar.translucent = NO;
     [[UINavigationBar appearance] setBarTintColor:[UIColor wineColor]];
     loginController.navigationItem.titleView = [VSViewController vineSpectatorView];
     
     loginController.logInView.logInButton.backgroundColor = [UIColor wineColor];
     [loginController.logInView.logInButton setBackgroundImage:nil
     forState:UIControlStateNormal];
     [loginController.logInView.signUpButton setBackgroundImage:nil
     forState:UIControlStateNormal];
     loginController.logInView.logInButton.backgroundColor = [UIColor wineColor];
     loginController.logInView.signUpButton.backgroundColor = [UIColor oliveInkColor];
//    [loginController.logInView.logInButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginController.delegate = self;
    
    UILabel *welcomeLabel = [UILabel new];
    welcomeLabel.text = @"Start your collection today.";
    welcomeLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:20.0];
    welcomeLabel.textColor = [UIColor wineColor];
    [loginController.view addSubview:welcomeLabel];
    [welcomeLabel sizeToFit];
    
    [welcomeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(loginController.logInView.centerX);
        make.bottom.equalTo(loginController.logInView.top).offset(125);
    }];
    
    PFSignUpViewController *signUpController = loginController.signUpController;
    signUpController.navigationController.navigationItem.titleView = [VSViewController vineSpectatorView];
    signUpController.view.backgroundColor = [UIColor parchmentColor];
    signUpController.signUpView.logo = self.logo;
    //[signUpController.signUpView.signUpButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];

    UIView *navBarView = [UIView new];
    navBarView.backgroundColor = [UIColor wineColor];
    [signUpController.signUpView addSubview:navBarView];
    
    [navBarView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.leading.trailing.equalTo(signUpController.signUpView);
        make.height.equalTo(55);
    }];
    
    [signUpController.signUpView.signUpButton setBackgroundImage:nil
                                                          forState:UIControlStateNormal];
    signUpController.signUpView.signUpButton.backgroundColor = [UIColor wineColor];
    signUpController.delegate = self;
    
    self.window.rootViewController = nc;
}

# pragma mark - PFSignUpViewControllerDelegate

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self showTableViewController];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(nullable NSError *)error
{
    
}

/**
 Sent to the delegate when the sign up screen is cancelled.
 
 @param signUpController The signup view controller where signup was cancelled.
 */
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    
}

- (UIView *)icon
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,375,375)];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colored-bottle-and-glass"]];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    [containerView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(containerView);
        make.leading.trailing.equalTo(containerView);
        make.height.equalTo(100);
    }];
    
    return containerView;
}


- (UIView *)logo
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,375,200)];
    
    UILabel *vineSpectator = [[UILabel alloc] init];
    
    UIFont *vineFont = [UIFont fontWithName:@"Didot-Bold" size:40.0];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *vineAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor wineColor], NSForegroundColorAttributeName,
                                    vineFont, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName,nil];
    NSMutableAttributedString *vineSpectatorString = [[NSMutableAttributedString alloc] initWithString:@"Vine " attributes:vineAttributes];
    
    
    UIFont *spectatorFont = [UIFont fontWithName:@"Athelas-Bold" size:40.0];
    NSDictionary *spectatorAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIColor goldColor], NSForegroundColorAttributeName,
                                         spectatorFont, NSFontAttributeName, nil];
    NSMutableAttributedString *spectatorString = [[NSMutableAttributedString alloc] initWithString:@"Spectator" attributes:spectatorAttributes];
    [vineSpectatorString appendAttributedString:spectatorString];
    
    vineSpectator.attributedText = vineSpectatorString;
    
    [containerView addSubview:vineSpectator];
    
    [vineSpectator mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(containerView);
        make.edges.equalTo(containerView);
    }];
    
    return containerView;
}


# pragma mark - PFLoginViewControllerDelegate

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self showTableViewController];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    
}
     
- (void)showTableViewController
{
    VSTableViewController *tv = [[VSTableViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tv];
    [[UINavigationBar appearance] setBarTintColor:[UIColor wineColor]];
    self.window.rootViewController = nc;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

@end
