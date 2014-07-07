//
//  TweetViewController.m
//  TwitterClient
//
//  Created by Kevin Ku on 7/6/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import "TweetViewController.h"

@interface TweetViewController ()

@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTweet:(NSDictionary *)tweet {
    self = [super init];
    if(self)
        self.tweet = tweet;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init reply button in navigation bar
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithTitle: @"Reply" style:UIBarButtonItemStyleBordered target:self action:@selector(onNavBarReplyButton)];
    replyButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:replyButton];
    
    // init views
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initViews {
    self.userNameLabel.text = self.tweet[@"user"][@"name"];
    self.userScreenNameLabel.text = [[NSString alloc] initWithFormat:@"@%@", self.tweet[@"user"][@"screen_name"]];
    self.tweetLabel.text = self.tweet[@"text"];
    self.timeLabel.text = [TimeFormatter getTweetTimeString:self.tweet[@"created_at"]];
    self.retweetsLabel.text = [[NSString alloc] initWithFormat:@"%@ RETWEETS", self.tweet[@"retweet_count"]];
    self.favoritesLabel.text = [[NSString alloc] initWithFormat:@"%@ FAVORITES", self.tweet[@"favorite_count"]];
    
    NSURL *userImgURL = [NSURL URLWithString:self.tweet[@"user"][@"profile_image_url"]];
    [self.userImageView setImageWithURL:userImgURL];
}

- (void)onNavBarReplyButton {
    
}

- (IBAction)onReplyButton:(id)sender {
}

- (IBAction)onRetweetButton:(id)sender {
}

- (IBAction)onFavoriteButton:(id)sender {
}
@end
