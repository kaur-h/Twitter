//
//  ComposeViewController.m
//  twitter
//
//  Created by Harleen Kaur on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@end

@implementation ComposeViewController

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

- (IBAction)tweetButtonClicked:(id)sender {
    NSString *tweetText = self.tweetTextView.text;
    [[APIManager shared] postStatusWithText:tweetText completion:^(Tweet *tweet, NSError *error) {
        if(tweet){
            [self.delegate didTweet:tweet];
            NSLog(@"Successfully posted tweet!");
            [self dismissViewControllerAnimated:true completion:nil];
        }else {
            NSLog(@"Error posting tweet: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
