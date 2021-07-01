//
//  ProfileViewController.m
//  twitter
//
//  Created by Harleen Kaur on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIManager.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[APIManager shared] getUserInfo:^(NSDictionary *userInfoDic, NSError *error) {
        if (userInfoDic) {
            NSLog(@"Successfully loaded user info");
            self.userNameLabel.text = userInfoDic[@"name"];
            self.screenNameLabel.text = userInfoDic[@"screen_name"];
            NSString *URLString = userInfoDic[@"profile_image_url_https"];
            NSURL *url = [NSURL URLWithString:URLString];
            
            self.profileImage.image = nil;
            [self.profileImage setImageWithURL:url];
            
        } else {
            NSLog(@" Error getting user info: %@", error.localizedDescription);
        }
    
    }];
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
