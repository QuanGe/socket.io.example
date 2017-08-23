//
//  ViewController.m
//  test
//
//  Created by 张汝泉 on 2017/8/18.
//  Copyright © 2017年 张汝泉. All rights reserved.
//
#define test 0
#import "ViewController.h"
@import SocketIO;
@interface ViewController ()
@property (nonatomic,readwrite,strong) SocketIOClient* socketIOClient;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    NSURL* url = [[NSURL alloc] initWithString:@"http://localhost:3000"];
    SocketIOClient* socket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES}];
    
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        [socket emit:@"update" with:@[@{@"amount": @(5 + 2.50)}]];
    }];
    
    [socket on:@"currentAmount" callback:^(NSArray* data, SocketAckEmitter* ack) {
        double cur = [[data objectAtIndex:0] floatValue];
        
        [[socket emitWithAck:@"canUpdate" with:@[@(cur)]] timingOutAfter:0 callback:^(NSArray* data) {
            [socket emit:@"update" with:@[@{@"amount": @(cur + 2.50)}]];
        }];
        
        [ack with:@[@"Got your currentAmount, ", @"dude"]];
    }];
    
    [socket connect];
     */
    
    
    // Do any additional setup after loading the view, typically from a nib.
    NSString* socketUrlString = test?@"http://localhost:3000":@"https://500px.me/";
    NSString* token = @"6B7E8DE33C6F30B827CC0BF04E1971E5DBB6ACF90C047FA1FF69663083BBA264DD71AA015DBE2926C08BEB51FFC39C3D66B7850E068202E6E45C4079351EF693B09EF946B1D0A05F34A6F893C9B44182473EEBCB06E62677D1EBC948D1EDDE758419DBE789856C442796749D7376917F9C6545C4FCD7DFBA";
    NSDictionary* config = test?@{@"log":@NO,@"forcePolling":@YES,@"reconnects":@YES}:@{@"connectParams":@{@"access_token":token},@"log":@NO,@"forcePolling":@YES,@"reconnects":@YES};
    
    self.socketIOClient = [[SocketIOClient alloc] initWithSocketURL:[NSURL URLWithString:socketUrlString] config:config];
    
    [self.socketIOClient on:@"connect" callback:^(NSArray * data, SocketAckEmitter * ack) {
        NSLog(@"socketIOClientConnect");
        NSLog(@"data = %@",data);
        [self.socketIOClient emit:@"message" with:@[@"心跳包"]];
    }];
    
    
    [self.socketIOClient on:@"disconnect" callback:^(NSArray * data, SocketAckEmitter * ack) {
        NSLog(@"socketIOClientDisconnect");
        NSLog(@"data = %@",data);
        
    }];
    
    [self.socketIOClient on:@"error" callback:^(NSArray * data, SocketAckEmitter * ack) {
        NSLog(@"socketIOClientError");
        NSLog(@"data = %@",data);
       
    }];
    
    [_socketIOClient on:@"reconnect" callback:^(NSArray * data, SocketAckEmitter * ack) {
        NSLog(@"socketIOClientReconnect");
        NSLog(@"data = %@",data);

    }];
    
    [self.socketIOClient on:@"message" callback:^(NSArray * data, SocketAckEmitter * ack) {
        NSLog(@"socketIOClientMessage");
        NSLog(@"data = %@",data);
        NSString *string =data[0];
        NSLog(@"Received \"%@\"", string);
    }];
    
    [_socketIOClient connect];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
