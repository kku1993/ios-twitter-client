//
//  TweetEditorViewController.m
//  TwitterClient
//
//  Created by Kevin Ku on 7/6/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import "TweetEditorViewController.h"

@interface TweetEditorViewController ()

@end

@implementation TweetEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMode:(int)mode {
    self = [super init];
    if(self) {
        self.mode = mode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.mode == 1) {
        // new tweet
        [self setTitle:@"New"];
    }
    else {
        // reply
        [self setTitle:@"Reply"];
    }
    
    // init tweet button in navigation bar
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle: @"Tweet" style:UIBarButtonItemStyleBordered target:self action:@selector(onTweetButton)];
    tweetButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:tweetButton];
    
    // get user info and populate views
    [self getUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initViews {
    if(!self.userInfo)
        return;
    
    NSURL *userImgURL = [NSURL URLWithString:self.userInfo[@"profile_image_url"]];
    [self.userImageView setImageWithURL:userImgURL];

    self.userNameLabel.text = self.userInfo[@"name"];
    self.userScreenNameLabel.text = self.userInfo[@"screen_name"];
    
    if(self.mode == 1) {
        // new tweet
        self.tweetTextView.text = @"";
    }
    else {
        // reply - extract tags from the post
        if(self.replyTweet)
            self.tweetTextView.text = [[NSString alloc] initWithFormat:@"@%@ ", self.replyTweet[@"user"][@"screen_name"]];
        else
            self.tweetTextView.text = @"";
    }
}

- (void) getUserInfo {
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"Loading" status:@""];
    
    // function to return to timeline if failed to load user info
    void (^goBack)(void) = ^{
        [MMProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:true];
    };
    
    [[TwitterAPI instance] getUserDetailWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MMProgressHUD dismiss];
        self.userInfo = responseObject;
        
        [self initViews];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD dismiss];
        NSLog(@"Failed to get user information. Error: %@", error);
        
        // update table view
        if([NSThread isMainThread]) {
            goBack();
        }
        else {
            dispatch_sync(dispatch_get_main_queue(), goBack);
        }
    }];
}

- (void)onTweetButton {
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"Tweeting" status:@""];
    
    [[TwitterAPI instance] postNewTweet:self.tweetTextView.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MMProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD dismiss];
        NSLog(@"Failed to post new tweet. Error: %@", error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to Tweet" message:@"Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

@end
