//
//  ViewController.m
//  GCD
//
//  Created by zyw on 14-5-22.
//  Copyright (c) 2014年 zyw. All rights reserved.
//

#import "ViewController.h"
#define kURL @"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    tickets = 100;
    count = 0;
}

- (void)threaddownloadImage:(NSString *)url
{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [[UIImage alloc] initWithData:data];
    if (image) {
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:YES];
    }
}

- (IBAction)threadsyn:(id)sender
{
    ticketsLock = [[NSLock alloc] init];
    
    ticketsCondition = [[NSCondition alloc] init];
    
    ticketsThreadone = [[NSThread alloc] initWithTarget:self selector:@selector(runsyn) object:nil];
    [ticketsThreadone setName:@"threadone"];
    [ticketsThreadone start];
    
    ticketsThreadtwo = [[NSThread alloc] initWithTarget:self selector:@selector(runsyn) object:nil];
    [ticketsThreadtwo setName:@"threadtwo"];
    [ticketsThreadtwo start];
    
}

- (IBAction)threadseq:(id)sender
{
    ticketsLock = [[NSLock alloc] init];
    
    ticketsCondition = [[NSCondition alloc] init];
    
    ticketsThreadone = [[NSThread alloc] initWithTarget:self selector:@selector(runseq) object:nil];
    [ticketsThreadone setName:@"threadone"];
    [ticketsThreadone start];
    
    ticketsThreadtwo = [[NSThread alloc] initWithTarget:self selector:@selector(runseq) object:nil];
    [ticketsThreadtwo setName:@"threadtwo"];
    [ticketsThreadtwo start];
    
    NSThread *ticketsThreadThree = [[NSThread alloc] initWithTarget:self selector:@selector(runlock) object:nil];
    [ticketsThreadThree setName:@"threadthree"];
    [ticketsThreadThree start];
}


- (IBAction)downloadImage:(id)sender
{
    NSThread *thread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(threaddownloadImage:)
                                                 object:kURL];
    [thread start];
}


- (IBAction)operationqueue:(id)sender
{
    NSInvocationOperation *operation  = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(threaddownloadImage:) object:kURL];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

- (IBAction)dispatchsyn:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:kURL]];
        UIImage *image = [[UIImage alloc] initWithData:data];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
            });
        }
    });
}

- (IBAction)dispatchgroup:(id)sender
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"group1");
    });
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"group2");
    });
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"group3");
    });
    
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"group4");
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"update");
    });
}

- (IBAction)dispatchbarrier:(id)sender
{
    dispatch_queue_t quque =  dispatch_queue_create("gcdtest.rongfzh.yc", DISPATCH_QUEUE_CONCURRENT);
     dispatch_async(quque, ^{
         [NSThread sleepForTimeInterval:2];
         NSLog(@"dispatch_async1");
     });
    
    dispatch_async(quque, ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"dispatch_async2");
    });
    
    dispatch_barrier_async(quque, ^{
        NSLog(@"dispatch_barrier_async");
        [NSThread sleepForTimeInterval:4];
    });
    
    dispatch_async(quque, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"dispatch_async3");
    });
    
}

- (void)runsyn
{
    while (TRUE) {
        [ticketsLock lock];

        // [ticketsCondition lock];
        
        if (tickets >= 0) {
            [NSThread sleepForTimeInterval:0.09];
            count = 100 -tickets;
            NSLog(@"当前票数是:%d,售出:%d,线程名:%@",tickets,count,[[NSThread currentThread] name]);
            tickets--;
        }else{
            break;
        }
        
        // [ticketsCondition unlock];
        [ticketsLock unlock];
    }
}

- (void)runseq
{
    while (TRUE) {
        
        [ticketsCondition lock];
        [ticketsCondition wait];
        [ticketsLock lock];
        
        if (tickets >= 0) {
            [NSThread sleepForTimeInterval:0.09];
            count = 100 - tickets;
            NSLog(@"当前票数是:%d,售出:%d,线程名:%@",tickets,count,[[NSThread currentThread] name]);
            tickets--;
        }else{
            break;
        }
        
        [ticketsLock unlock];
        [ticketsCondition unlock];
    }
}

- (void)runlock
{
    while (YES) {
        [ticketsCondition lock];
        [NSThread sleepForTimeInterval:3];
        [ticketsCondition signal];
        [ticketsCondition unlock];
    }
}

- (void)updateImage:(UIImage *)image
{
    imageView.image = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
