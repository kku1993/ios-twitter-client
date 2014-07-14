//
//  UserProfileViewController.h
//  TwitterClient
//
//  Created by Kevin Ku on 7/13/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

#import "TimelineCell.h"
#import "TweetViewController.h"

@interface UserProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSDictionary *userData;
@property (nonatomic) NSString *userScreenName;
@property (nonatomic) NSArray *userTweets;

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *userTweetsTableView;

-(id)initWithUserScreenName:(NSString *)name;

@end
