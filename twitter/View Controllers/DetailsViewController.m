//
//  DetailsViewController.m
//  twitter
//
//  Created by Harleen Kaur on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "TimelineViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    //NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    self.profileImage.image = nil;
    [self.profileImage setImageWithURL:url];
    
    self.userNameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = self.tweet.user.screenName;
    
    //formatting date
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"MM/dd/yy,h:mm a";
//    NSDate *date = [formatter dateFromString:self.tweet.createdAtString];
//    NSString *ago = date.shortTimeAgoSinceNow;
    self.tweetDate.text = self.tweet.createdAtString;
    
    
    self.tweetText.text = self.tweet.text;
    
    [self favoritedOrRetweeteed];
    
}

-(void) favoritedOrRetweeteed{
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    if(self.tweet.favorited){
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    }
    else{
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    }
    
    if(self.tweet.retweeted){
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    }
    else{
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:@"refreshTableView" object:nil];
    
}
- (IBAction)didTapRetweet:(id)sender {
    //if already retweeted then unretweet
    if(self.tweet.retweeted){
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        //POST unfavorite endpoint
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
       [self favoritedOrRetweeteed];
    }
    else{
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        // POST favorite endpoint
         [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
        [self favoritedOrRetweeteed];
    }
}
- (IBAction)didTapFavorite:(id)sender {
    //if already favorited then unfavorite
    if(self.tweet.favorited){
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        //POST unfavorite endpoint
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
       [self favoritedOrRetweeteed];
    }
    else{
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        // POST favorite endpoint
         [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
        [self favoritedOrRetweeteed];
    }
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
