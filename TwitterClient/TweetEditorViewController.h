//
//  TweetEditorViewController.h
//  TwitterClient
//
//  Created by Kevin Ku on 7/6/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMProgressHUD/MMProgressHUD.h>
#import <UIImageView+AFNetworking.h>

#import "TwitterAPI.h"

@interface TweetEditorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@property (nonatomic) NSDictionary *userInfo;
@property (nonatomic) NSDictionary *replyTweet; // the tweet being replied to
@property (nonatomic) int mode;

- (id)initWithMode:(int)mode;

@end
