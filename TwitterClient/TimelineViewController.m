//
//  TimelineViewController.m
//  TwitterClient
//
//  Created by Kevin Ku on 7/6/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import "TimelineViewController.h"

@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.menuViewController = [[MenuViewController alloc] init];
        self.userProfileViewController = [[UserProfileViewController alloc] init];
        self.mentionsViewController = [[MentionsViewController alloc] init];
        self.isMovingMenu = false;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timelineTableView.delegate = self;
    self.timelineTableView.dataSource = self;
    
    // pull down to refresh feature
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.timelineTableView;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadTimeline) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    // initialize navigation bar
    [self initNavBar];
    
    // get timeline data
    [self loadTimeline];
    
    // register handler for reply button from tabelviewcell
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReplyButton:) name:@"replyButtonNotification" object:nil];
    
    // register handler for menu option items
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMenuOptionSelected:) name:@"menuOptionSelectedNotification" object:nil];
    
    // register handler for user image click event
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserImageClicked:) name:@"timelineUserImageClicked" object:nil];
    
    // init swipe to show menu
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.containerView addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.containerView addGestureRecognizer:self.rightSwipeGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// title bar functions
- (void) initNavBar {
    /*
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle: @"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(onLogoutButton)];
    logoutButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:logoutButton];
     */
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle: @"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(onMenuButton)];
    menuButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:menuButton];
    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle: @"New" style:UIBarButtonItemStyleBordered target:self action:@selector(onNewTweetButton)];
    tweetButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:tweetButton];
    
    self.navigationItem.title = @"Home";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0 green:172/255.0 blue:238/255.0 alpha:1];
}

- (void)onMenuButton {
    if(self.menuViewController.isShowing) {
        [self hideMenu];
        return;
    }
    
    [self showMenu];
}

- (void)showMenu {
    if(!self.isMovingMenu && !self.menuViewController.isShowing) {
        self.isMovingMenu = true;
        
        [self addChildViewController:self.menuViewController];
        [self.menuViewController willMoveToParentViewController:self];
        [self.view addSubview:self.menuViewController.view];
        
        float xOffset = 250;
        self.menuViewController.view.frame = CGRectMake(0, 0, xOffset, self.containerView.frame.size.height);
        
        // animation
        CGPoint originalCenter = self.containerView.center;
        self.menuViewController.view.center = CGPointMake(-xOffset/2, originalCenter.y);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationCurveEaseInOut animations:^{
            self.menuViewController.view.center = CGPointMake(xOffset/2, originalCenter.y);
            self.containerView.center = CGPointMake(originalCenter.x + xOffset, originalCenter.y);
        } completion:^(BOOL finished) {
            self.containerView.frame = CGRectMake(xOffset, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
            [self.menuViewController didMoveToParentViewController:self];
            self.menuViewController.isShowing = true;
            self.isMovingMenu = false;
        }];
    }
}

- (void)hideMenu {
    if(!self.isMovingMenu && self.menuViewController.isShowing) {
        self.isMovingMenu = true;
        
        [self.menuViewController willMoveToParentViewController:nil];
        float xOffset = 250;
        
        // animation
        CGPoint originalCenter = self.containerView.center;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationCurveEaseInOut animations:^{
            self.menuViewController.view.center = CGPointMake(-xOffset/2, originalCenter.y);
            self.containerView.center = CGPointMake(originalCenter.x - xOffset, originalCenter.y);
        } completion:^(BOOL finished) {
            [self.menuViewController.view removeFromSuperview];
            self.containerView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
            [self.menuViewController didMoveToParentViewController:nil];
            self.menuViewController.isShowing = false;
            self.isMovingMenu = false;
        }];
    }
}

- (void)onNewTweetButton {
    TweetEditorViewController *tevc = [[TweetEditorViewController alloc] initWithMode:1];
    [self.navigationController pushViewController:tevc animated:true];
}

- (void)logout {
    [[TwitterAPI instance] logout];
    
    LogInViewController *lvc = [[LogInViewController alloc] init];
    [self presentViewController:lvc animated:true completion:^{
        NSLog(@"User Logged Out");
    }];
}

// pull down to refresh functions
- (UIView *) makeErrorBox:(NSString *)errMsg {
    UIView *errorBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    UITextField *errorTextField = [[UITextField alloc] initWithFrame:errorBox.frame];
    errorTextField.text = errMsg;
    errorTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    errorTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    errorTextField.textAlignment = NSTextAlignmentCenter;
    errorTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    errorTextField.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [errorBox addSubview:errorTextField];
    
    return errorBox;
}

- (void)loadTimeline {
    // show progress dialog
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"Loading" status:@"Updating Your Timeline"];
    
    // async load timeline
    [[TwitterAPI instance] getHomeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self onTimelineLoaded:operation :responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self onTimelineLoadError:operation :error];
    }];
}

- (void)onTimelineLoaded:(AFHTTPRequestOperation *)op :(id)data {
    self.timelineData = data;
    
    void (^updateUI)(void) = ^{
        // make sure error box is not showing
        self.timelineTableView.tableHeaderView = nil;
        
        [MMProgressHUD dismiss];
        [self.refreshControl endRefreshing];
        [self.timelineTableView reloadData];
    };
    
    // update table view
    if([NSThread isMainThread]) {
        updateUI();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), updateUI);
    }
}

- (void)onTimelineLoadError:(AFHTTPRequestOperation *)op :(NSError *)err {
    NSLog(@"%@", [err localizedDescription]);
    
    [MMProgressHUD dismiss];
    [self.refreshControl endRefreshing];
    self.timelineTableView.tableHeaderView = [self makeErrorBox:@"Network Error!"];
}

// table view functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.timelineData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TimelineCell";
    
    TimelineCell *cell = [self.timelineTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimelineCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.tweet = [self.timelineData objectAtIndex:indexPath.row];
    return [cell updateViews];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // open tweet detail view
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    TweetViewController *tvc = [[TweetViewController alloc] initWithTweet:[self.timelineData objectAtIndex:indexPath.row]];
    [tvc setTitle:@"Tweet"];
    
    [self.navigationController pushViewController:tvc animated:true];
}

// user controls

- (void)onReplyButton:(NSNotification *)notification {
    NSDictionary *tweet = notification.userInfo;
    
    TweetEditorViewController *tevc = [[TweetEditorViewController alloc] initWithMode:2];
    tevc.replyTweet = tweet;
    [self.navigationController pushViewController:tevc animated:true];
}

// controls for a child view controller
- (void)showSubViewController:(UIViewController *)vc {
    if(self.frontViewController) {
        // remove front controller before adding new one
        [self hideSubViewController:self.frontViewController];
        self.frontViewController = nil;
    }
    
    vc.view.frame = self.containerView.frame;
    
    [self addChildViewController:vc];
    [vc willMoveToParentViewController:self];
    [self.view addSubview:vc.view];
    
    self.frontViewController = vc;
    [vc didMoveToParentViewController:self];
}

- (void)hideSubViewController:(UIViewController *)vc {
    [vc.view removeFromSuperview];
    [vc didMoveToParentViewController:nil];
}

- (void)showUserProfile:(NSString *)screenName {
    self.userProfileViewController.userScreenName = screenName;
    [self showSubViewController:self.userProfileViewController];
}

- (void)showMentions {
    [self showSubViewController:self.mentionsViewController];
}

- (void)onMenuOptionSelected:(NSNotification *)notification {
    NSIndexPath *indexPath = [notification.userInfo objectForKey:@"IndexPath"];
    
    [self hideMenu];
    switch(indexPath.row) {
        case 0:
            // profile
            [self showUserProfile:nil];
            break;
        case 1:
            // timeline
            if(self.frontViewController) {
                // remove front controller
                [self hideSubViewController:self.frontViewController];
                self.frontViewController = nil;
            }
            break;
        case 2:
            // mentions
            [self showMentions];
            break;
        case 3:
            // logout
            [self logout];
            break;
        default:
            NSLog(@"Invalid Menu Option Selected");
            break;
    }
}

- (void)onSwipeGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    if(swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self showMenu];
    }
    else if(swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self hideMenu];
    }
}

- (void) onUserImageClicked:(NSNotification *)notification {
    NSDictionary *tweet = notification.userInfo;
    if(!tweet)
        return;
    [self showUserProfile:tweet[@"user"][@"screen_name"]];
}
@end
