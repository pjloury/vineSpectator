//
//  VSViewController.m
//  VineSpectator
//
//  Created by PJ Loury on 12/23/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSViewController.h"

@interface VSViewController ()

@end

@implementation VSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [[UINavigationBar appearance] setTintColor:[UIColor pateColor]];
    self.navigationItem.titleView = [self vineSpectatorView];
    //self.navigationController.navigationBar.userInteractionEnabled = YES;
    //self.navigationItem.titleView.userInteractionEnabled = YES;
}

+ (UIView *)vineSpectatorView
{
    UILabel *vineSpectator = [[UILabel alloc] initWithFrame:CGRectMake(0,0,250.0,50)];
    //    UILabel *vineSpectator = [[UILabel alloc] initWithFrame:CGRectMake(0,0,250.0,CGRectGetHeight(self.navigationController.navigationBar.frame))];
    
    UIFont *vineFont = [UIFont fontWithName:@"Didot-Bold" size:24.0];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *vineAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor pateColor], NSForegroundColorAttributeName,
                                    vineFont, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName,nil];
    NSMutableAttributedString *vineSpectatorString = [[NSMutableAttributedString alloc] initWithString:@"Vine " attributes:vineAttributes];
    
    
    UIFont *spectatorFont = [UIFont fontWithName:@"Athelas-Bold" size:24.0];
    NSDictionary *spectatorAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIColor goldColor], NSForegroundColorAttributeName,
                                         spectatorFont, NSFontAttributeName, nil];
    NSMutableAttributedString *spectatorString = [[NSMutableAttributedString alloc] initWithString:@"Spectator" attributes:spectatorAttributes];
    [vineSpectatorString appendAttributedString:spectatorString];
    
    vineSpectator.attributedText = vineSpectatorString;
    
    return vineSpectator;
}

- (UIView *)vineSpectatorView
{
    UILabel *vineSpectator = [[UILabel alloc] initWithFrame:CGRectMake(0,0,250.0,50)];
    //    UILabel *vineSpectator = [[UILabel alloc] initWithFrame:CGRectMake(0,0,250.0,CGRectGetHeight(self.navigationController.navigationBar.frame))];
    
    UIFont *vineFont = [UIFont fontWithName:@"Didot-Bold" size:24.0];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *vineAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor pateColor], NSForegroundColorAttributeName,
                                    vineFont, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName,nil];
    NSMutableAttributedString *vineSpectatorString = [[NSMutableAttributedString alloc] initWithString:@"Vine " attributes:vineAttributes];
    
    
    UIFont *spectatorFont = [UIFont fontWithName:@"Athelas-Bold" size:24.0];
    NSDictionary *spectatorAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIColor goldColor], NSForegroundColorAttributeName,
                                         spectatorFont, NSFontAttributeName, nil];
    NSMutableAttributedString *spectatorString = [[NSMutableAttributedString alloc] initWithString:@"Spectator" attributes:spectatorAttributes];
    [vineSpectatorString appendAttributedString:spectatorString];
    
    vineSpectator.attributedText = vineSpectatorString;
    
//    UIButton *butt = [[UIButton alloc] initWithFrame:vineSpectator.frame];
//    [vineSpectator addSubview:butt];
//    [butt addTarget:self action:@selector(titleViewTapped) forControlEvents:UIControlEventTouchUpInside];
    
    return vineSpectator;
}

//+ (UIButton *)vineSpectatorView
//{
//    UIButton *butt = [[UIButton alloc] initWithFrame:CGRectMake(0,0,250.0,50)];
//    [butt addTarget:self action:@selector(titleViewTapped) forControlEvents:UIControlEventTouchUpInside];
//    [butt setBackgroundColor:[UIColor redColor]];
//    
//    return butt;
//}


- (void)titleViewTapped {
    
}

@end
