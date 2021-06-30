//
//  DetailsViewController.h
//  twitter
//
//  Created by Harleen Kaur on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) Tweet *tweet;
-(void) favoritedOrRetweeteed;

@end

NS_ASSUME_NONNULL_END
