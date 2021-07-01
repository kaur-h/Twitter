//
//  ProfileViewController.m
//  twitter
//
//  Created by Harleen Kaur on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self didTapProfile];
    // Do any additional setup after loading the view.
}

-(void)didTapProfile{
    [[APIManager shared] getUserInfoBasedOnName:self.user.name completion:^(User *user, NSError *error){
        if(error){
             NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully found user info");
            self.userNameLabel.text = self.user.name;
            self.screenNameLabel.text = self.user.screenName;
            self.followingCount.text = self.user.followingCount;
            self.followersCount.text = self.user.followersCount;
            
            //Profile Image
            NSString *URLString = self.user.profilePicture;
            NSURL *url = [NSURL URLWithString:URLString];
            NSLog(@"%@", URLString);
            self.profileImage.image = nil;
            [self.profileImage setImageWithURL:url];
            
            //Backdrop Image
            NSString *URLStringBackdrop = self.user.backgroundPicture;
            if(!URLStringBackdrop){
                NSURL *urlbackdrop = [NSURL URLWithString:URLStringBackdrop];

                self.backdropImage.image = nil;
                [self.backdropImage setImageWithURL:urlbackdrop];
            }

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
