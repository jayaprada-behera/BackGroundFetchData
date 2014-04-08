//
//  WARootViewController.h
//  BGFetchDemo
//
//  Created by Jayaprada Behera on 08/04/14.
//  Copyright (c) 2014 Webileapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WARootViewController : UIViewController
-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
