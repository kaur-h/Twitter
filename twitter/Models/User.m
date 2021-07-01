//
//  User.m
//  twitter
//
//  Created by Harleen Kaur on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = [@"@" stringByAppendingString:dictionary[@"screen_name"]];
        self.profilePicture = dictionary[@"profile_image_url_https"];
        self.backgroundPicture = dictionary[@"profile_background_image_url_https"];
        NSLog(@"%@", self.backgroundPicture);
        self.followersCount = [NSString stringWithFormat:@"%@", dictionary[@"followers_count"]];
        self.followingCount = [NSString stringWithFormat:@"%@", dictionary[@"friends_count"]];  
    // Initialize any other properties
    }
    return self;
}

@end
