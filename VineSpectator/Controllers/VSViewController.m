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
    UILabel *vineSpectator = [[UILabel alloc] initWithFrame:CGRectMake(0,0,250.0,CGRectGetHeight(self.navigationController.navigationBar.frame))];
    
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
    self.navigationItem.titleView = vineSpectator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
