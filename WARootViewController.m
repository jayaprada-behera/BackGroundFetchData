//
//  WARootViewController.m
//  BGFetchDemo
//
//  Created by Jayaprada Behera on 08/04/14.
//  Copyright (c) 2014 Webileapps. All rights reserved.
//

#import "WARootViewController.h"
#import "XMLParser.h"

#define NewsFeed @"http://feeds.reuters.com/reuters/technologyNews"

@interface WARootViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSArray *arrNewsData;

@property (nonatomic, strong) NSString *dataFilePath;

@property(nonatomic,weak)IBOutlet UITableView *myTableView;

-(void)performNewFetchedDataActionsWithDataArray:(NSArray *)dataArray;

@end

@implementation WARootViewController

@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 1. Specify the data storage file path.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    self.dataFilePath = [docDirectory stringByAppendingPathComponent:@"newsdata"];

    // 2. Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshData)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.myTableView addSubview:self.refreshControl];

    if ([[NSFileManager defaultManager] fileExistsAtPath:self.dataFilePath]) {
        self.arrNewsData = [[NSMutableArray alloc] initWithContentsOfFile:self.dataFilePath];
        
        [self.myTableView reloadData];
    }

    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = refreshBarButton;
    
    
}
-(void)refreshData{
    
    XMLParser *xmlParser = [[XMLParser alloc] initWithXMLURLString:NewsFeed];
    [xmlParser startParsingWithCompletionHandler:^(BOOL success, NSArray *dataArray, NSError *error) {
        if (success) {
            [self performNewFetchedDataActionsWithDataArray:dataArray];
            
            [self.refreshControl endRefreshing];
        }
        else{
            NSLog(@"%@", [error localizedDescription]);
        }
        
    }];

}
-(void)performNewFetchedDataActionsWithDataArray:(NSArray *)dataArray{
    // 1. Initialize the arrNewsData array with the parsed data array.
    if (self.arrNewsData != nil) {
        self.arrNewsData = nil;
    }
    self.arrNewsData = [[NSArray alloc] initWithArray:dataArray];
    
    // 2. Reload the table view.
    [self.myTableView reloadData];
    
    // 3. Save the data permanently to file.
    if (![self.arrNewsData writeToFile:self.dataFilePath atomically:YES]) {
        NSLog(@"Couldn't save data.");
    }
}
-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
 
    XMLParser *xmlParser = [[XMLParser alloc] initWithXMLURLString:NewsFeed];
    
    [xmlParser startParsingWithCompletionHandler:^(BOOL success, NSArray *dataArray, NSError *error) {
        if (success) {
            NSDictionary *latestDataDict = [dataArray objectAtIndex:0];
            NSString *latestTitle = [latestDataDict objectForKey:@"title"];
            
            NSDictionary *existingDataDict = [self.arrNewsData objectAtIndex:0];
            NSString *existingTitle = [existingDataDict objectForKey:@"title"];
            
            if ([latestTitle isEqualToString:existingTitle]) {
                completionHandler(UIBackgroundFetchResultNoData);
                
                NSLog(@"No new data found.");
            }
            else{
                [self performNewFetchedDataActionsWithDataArray:dataArray];
                
                completionHandler(UIBackgroundFetchResultNewData);
                
                NSLog(@"New data was fetched.");
            }
        }
        else{
            completionHandler(UIBackgroundFetchResultFailed);
            
            NSLog(@"Failed to fetch new data.");
        }
    }];

}
#pragma mark - UITABLEVIEWDATASOURCE UITABLEVIEWDELEGATE

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrNewsData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentififer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dict = [self.arrNewsData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dict objectForKey:@"title"];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.f];
    
    cell.detailTextLabel.text = [dict objectForKey:@"pubDate"];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.f;
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
