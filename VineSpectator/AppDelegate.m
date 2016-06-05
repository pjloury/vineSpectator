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
#import <ParseFacebookUtils/PFFacebookUtils.h>

// UPC Database API Key 442da679c3863c3a5eb3166f7c11988f
// http://api.upcdatabase.org/json/442da679c3863c3a5eb3166f7c11988f/0111222333446

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
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (![PFUser currentUser]) {
            [self showLoginViewController];
    } else {
        [self showTableViewController];
    }
    
    [PFConfig getConfigInBackground];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)showLoginViewController
{
     PFLogInViewController *loginController = [[PFLogInViewController alloc] init];
     loginController.fields = (PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton |
     PFLogInFieldsFacebook | PFLogInFieldsPasswordForgotten);
     loginController.view.backgroundColor = [UIColor parchmentColor];
     loginController.logInView.logo = self.placeholder;

     UIView *logo = self.icon;
     [loginController.logInView addSubview:logo];
    
     UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:loginController];
     nc.navigationBar.translucent = NO;
     [[UINavigationBar appearance] setBarTintColor:[UIColor wineColor]];
     loginController.navigationItem.titleView = [VSViewController vineSpectatorView];
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat offset = height * 0.06;
    
    if (height < 500) { // iPhone 4
        logo.hidden = YES;
    }
    else if (height < 600) { // iPhone 5
        offset = 30;
    }
    else if (height < 700) { // iPhone 6
        offset = 70;
    }
    else if (height < 800) { // iPhone 6 Plus
        offset = 100;
    }
    else if (height < 1100) { // iPad
        offset = 150;
    }
    else { // 1366 iPad Pro
        offset = 225;
    }
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(loginController.view.top).offset(offset);
        make.centerX.equalTo(loginController.logInView.centerX);
    }];
    
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
    UIView *p = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
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
