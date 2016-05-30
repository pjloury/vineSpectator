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
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

// Toggle Tags when in Edit mode
// Drunk Bottles should be removed from Chrono
// Trim the String when Grape Variety used to create a new type

// Better Clock & Search Icons
// rely on the local cache, THEN attempt to fetch from the network.
// Tap Top of Nav Bar to Scroll to Top

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

    [Parse enableLocalDatastore];
   
    // Initialize Parse.
    [Parse setApplicationId:@"DtRXJrCQggcg4o1L1t34CMpPS5tFwe4Crc88Y0hE"
                  clientKey:@"HuXWIX37b4gonGqBKdK6EKdrlTR4BYjCQkVh15aF"];
    
    [PFFacebookUtils initializeFacebook];
    
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
     PFLogInFieldsFacebook | PFLogInFieldsPasswordForgotten);
     loginController.view.backgroundColor = [UIColor parchmentColor];
     loginController.logInView.logo = self.placeholder;
    
     UIView *logo = self.icon;
     [loginController.logInView addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(loginController.logInView.top).offset(20);
        make.centerX.equalTo(loginController.logInView.centerX);
    }];
    
     UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:loginController];
     nc.navigationBar.translucent = NO;
     [[UINavigationBar appearance] setBarTintColor:[UIColor wineColor]];
     loginController.navigationItem.titleView = [VSViewController vineSpectatorView];
     
     loginController.logInView.logInButton.backgroundColor = [UIColor wineColor];
     loginController.logInView.signUpButton.layer.cornerRadius = 4.0;
    
     [loginController.logInView.logInButton setBackgroundImage:nil
     forState:UIControlStateNormal];
     [loginController.logInView.signUpButton setBackgroundImage:nil
     forState:UIControlStateNormal];
     loginController.logInView.logInButton.backgroundColor = [UIColor wineColor];
     loginController.logInView.signUpButton.backgroundColor = [UIColor oliveInkColor];

    loginController.delegate = self;
    
    PFSignUpViewController *signUpController = loginController.signUpController;
    signUpController.navigationController.navigationItem.titleView = [VSViewController vineSpectatorView];
    signUpController.view.backgroundColor = [UIColor parchmentColor];
    signUpController.signUpView.logo = self.logo;

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

- (UIView *)placeholder {
    UIView *p = [[UIView alloc] initWithFrame:CGRectMake(0,0,350,350)];
    p.backgroundColor = [UIColor clearColor];
    return p;
}

- (UIView *)icon
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colored-bottle-and-glass"]];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:iconView];
    
    UILabel *welcomeLabel = [UILabel new];
    welcomeLabel.text = @"Start your collection today.";
    welcomeLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:18.0];
    welcomeLabel.textColor = [UIColor wineColor];
    [welcomeLabel sizeToFit];
    [containerView addSubview:welcomeLabel];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(containerView.top);
        make.height.equalTo(80);
        make.width.equalTo(80);
        make.centerX.equalTo(containerView.centerX);
        make.bottom.equalTo(welcomeLabel.top).offset(-20);
    }];
    
    [welcomeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(containerView.centerX);
        make.top.equalTo(iconView.bottom).offset(20);
        make.trailing.equalTo(containerView.trailing);
        make.leading.equalTo(containerView.leading);
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

- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

# pragma mark - PFLoginViewControllerDelegate

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self showTableViewController];
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
