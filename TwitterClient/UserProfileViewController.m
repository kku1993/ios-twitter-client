//
//  UserProfileViewController.m
//  TwitterClient
//
//  Created by Kevin Ku on 7/13/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(id)initWithUserScreenName:(NSString *)name {
    self = [super init];
    if(self) {
        self.userScreenName = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userTweetsTableView.delegate = self;
    self.userTweetsTableView.dataSource = self;
    
    [self getUserInfo];
    [self getUserTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews {
    if(self.userData) {
        NSURL *userImgURL = [NSURL URLWithString:self.userData[@"profile_image_url"]];
        [self.userImageView setImageWithURL:userImgURL];
        
        if(self.userData[@"profile_background_image_url"]) {
            NSURL *userBannerImgURL = [NSURL URLWithString:self.userData[@"profile_background_image_url"]];
            [self.bannerImageView setImageWithURL:userBannerImgURL];
        }
        else {
            self.bannerImageView.backgroundColor = [UIColor grayColor];
        }
        
        
        self.userNameLabel.text = self.userData[@"name"];
        self.userScreenNameLabel.text = [[NSString alloc] initWithFormat:@"@%@", self.userData[@"screen_name"]];
    }
}

- (void) getUserInfo {
    if(!self.userScreenName) {
        // get profile of current logged in user
        [[TwitterAPI instance] getUserDetailWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.userData = responseObject;
            self.userScreenName = self.userData[@"screen_name"];
            
            [self initViews];
            
            if(!self.userTweets) {
                [self getUserTweets];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to get user information. Error: %@", error);
        }];
    }
    else {
        [[TwitterAPI instance] getUserDataWithScreenName:self.userScreenName success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.userData = responseObject;
            
            [self initViews];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Failed to get user information. Error: %@", error);
        }];
    }
}

- (void) getUserTweets{
    if(!self.userScreenName)
        return;
    [[TwitterAPI instance] getTimelineWithScreenName:self.userScreenName success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.userTweets = responseObject;
        
        void (^updateUI)(void) = ^{
            // make sure error box is not showing
            [self.userTweetsTableView reloadData];
        };
        
        // update table view
        if([NSThread isMainThread]) {
            updateUI();
        }
        else {
            dispatch_sync(dispatch_get_main_queue(), updateUI);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failde to get user's tweets. Error:%@", error);
    }];
}

// table view functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.userTweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TimelineCell";
    
    TimelineCell *cell = [self.userTweetsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimelineCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.tweet = [self.userTweets objectAtIndex:indexPath.row];
    return [cell updateViews];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // open tweet detail view
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    TweetViewController *tvc = [[TweetViewController alloc] initWithTweet:[self.userTweets objectAtIndex:indexPath.row]];
    [tvc setTitle:@"Tweet"];
    
    [self.navigationController pushViewController:tvc animated:true];
}


@end
