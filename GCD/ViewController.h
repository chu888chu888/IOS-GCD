//
//  ViewController.h
//  GCD
//
//  Created by zyw on 14-5-22.
//  Copyright (c) 2014年 zyw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    int tickets;
    int count;
    
    NSThread *ticketsThreadone;
    NSThread *ticketsThreadtwo;
    
    NSLock   *ticketsLock;
    
    NSCondition *ticketsCondition;
    
    __weak IBOutlet UIImageView *imageView;
}

- (IBAction)downloadImage:(id)sender;

- (IBAction)threadsyn:(id)sender;

- (IBAction)threadseq:(id)sender;

- (IBAction)operationqueue:(id)sender;

- (IBAction)dispatchsyn:(id)sender;

- (IBAction)dispatchgroup:(id)sender;

- (IBAction)dispatchbarrier:(id)sender;

@end
