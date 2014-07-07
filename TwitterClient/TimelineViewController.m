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
        // Custom initialization
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// title bar functions
- (void) initNavBar {
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle: @"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(onLogoutButton)];
    logoutButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:logoutButton];
    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle: @"New" style:UIBarButtonItemStyleBordered target:self action:@selector(onNewTweetButton)];
    tweetButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:tweetButton];
    
    self.navigationItem.title = @"Home";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0 green:172/255.0 blue:238/255.0 alpha:1];
}
     
- (void)onLogoutButton {
    [[TwitterAPI instance] logout];
    
    LogInViewController *lvc = [[LogInViewController alloc] init];
    [self presentViewController:lvc animated:true completion:^{
        NSLog(@"User Logged Out");
    }];
}

- (void)onNewTweetButton {
    
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
    // open restaurant detail view
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


@end
