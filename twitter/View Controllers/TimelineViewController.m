//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (nonatomic,strong) UIRefreshControl *refreshControl;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchTimeLine];
    
    //Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = UIColor.blackColor;
    [self.refreshControl addTarget:self action:@selector(fetchTimeLine) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadTableView) name:@"refreshTableView" object:nil];
    
}

- (void) fetchTimeLine {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.arrayOfTweets = tweets;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            
//            for (NSDictionary *dictionary in tweets) {
//                NSString *text = dictionary[@"text"];
//                NSLog(@"%@", text);
//            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButtonClicked:(id)sender {
    //logout and change root view back to login page
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
    //return 20;
}

- (UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Display the tweet cell with all the information from the tweet at the current index in array
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
//    NSString *URLString = tweet.user.profilePicture;
//    NSURL *url = [NSURL URLWithString:URLString];
//    //NSData *urlData = [NSData dataWithContentsOfURL:url];
//
//    cell.userImage.image = nil;
//    [cell.userImage setImageWithURL:url];
//
//    cell.usernameLabel.text = tweet.user.name;
//    cell.screenNameLabel.text = tweet.user.screenName;
//    cell.dateLabel.text = tweet.createdAtString;
//    cell.tweetText.text = tweet.text;
//
//    cell.retweetCount.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
//    cell.favoriteCount.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];

    cell.tweet = tweet;
    [cell refreshData];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Pass the newt tweet information to the composeViewController
    if([segue.identifier isEqualToString: @"composeView"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    if([segue.identifier isEqualToString: @"detailsView"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        DetailsViewController *detailController = [segue destinationViewController];
        detailController.tweet = tweet;
    }
    
}

- (void)didTweet:(nonnull Tweet *)tweet {
    //new tweet added to timeline and reload timeline to display new tweet
    [self.arrayOfTweets addObject:tweet];
    [self.tableView reloadData];
}
-(void)reloadTableView{
    [self.tableView reloadData];
}
@end
