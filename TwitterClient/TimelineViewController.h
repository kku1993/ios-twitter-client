//
//  TimelineViewController.h
//  TwitterClient
//
//  Created by Kevin Ku on 7/6/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMProgressHUD/MMProgressHUD.h>

#import "LogInViewController.h"
#import "TimelineCell.h"
#import "TwitterAPI.h"
#import "TweetViewController.h"
#import "TweetEditorViewController.h"

#import "MenuViewController.h"
#import "UserProfileViewController.h"

@interface TimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray *timelineData;

// the current view controller at the front
@property (nonatomic) UIViewController *frontViewController;

@property (nonatomic) MenuViewController *menuViewController;
@property (nonatomic) BOOL isMovingMenu;

@property (nonatomic) UserProfileViewController *userProfileViewController;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end
