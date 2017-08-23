//
//  ViewController.m
//  trySwift
//
//  Created by 张汝泉 on 2017/8/19.
//  Copyright © 2017年 张汝泉. All rights reserved.
//

#import "ViewController.h"

@import SocketIO;
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (nonatomic,readwrite,strong) SocketIOClient* socketIOClient;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString* socketUrlString = @"https://500px.me/";
    NSString* token = @"6B7E8DE33C6F30B827CC0BF04E1971E5DBB6ACF90C047FA1B9D94279E12E1E6198EC01343D2C8830C08BEB51FFC39C3D66B7850E068202E6E45C4079351EF693B09EF946B1D0A05F34A6F893C9B441825D286FC09BFCAB630505BFA233AAA57EFC9DF2CC536775E4ACAE28E4680B22C80132C39016D23E33";
    //    NSDictionary* config = @{@"Log": @NO, @"ForcePolling": @YES,@"Reconnects":@YES,@"ConnectParams":@{@"access_token":token}};
    NSDictionary* config = @{@"connectParams":@{@"access_token":token},@"log":@NO,@"forcePolling":@YES,@"reconnects":@YES,@"doubleEncodeUTF8":@(YES)};
    
    self.socketIOClient = [[SocketIOClient alloc] initWithSocketURL:[NSURL URLWithString:socketUrlString] config:config];
    
    [self.socketIOClient on:@"connect" callback:^(NSArray * data, SocketAckEmitter * ack) {
        NSLog(@"socketIOClientConnect");
        NSLog(@"data = %@",data);
        
    }];
    
    
    [self.socketIOClient on:@"disconnect" callback:^(NSArray * data, SocketAckEmitter * ack) {
        NSLog(@"socketIOClientDisconnect");
        NSLog(@"data = %@",data);
        self.socketIOClient = [[SocketIOClient alloc] initWithSocketURL:[NSURL URLWithString:socketUrlString] config:config];
        
    }];
    
    [self.socketIOClient on:@"error" callback:^(NSArray * data, SocketAckEmitter * ack) {
        NSLog(@"socketIOClientError");
        NSLog(@"data = %@",data);
        self.socketIOClient = [[SocketIOClient alloc] initWithSocketURL:[NSURL URLWithString:socketUrlString] config:config];
        
    }];
    //
    //    [_socketIOClient on:@"reconnect" callback:^(NSArray * data, SocketAckEmitter * ack) {
    //        NSLog(@"socketIOClientReconnect");
    //        NSLog(@"data = %@",data);
    //
    //    }];
    
    [self.socketIOClient on:@"message" callback:^(NSArray * data, SocketAckEmitter * ack) {
        NSLog(@"socketIOClientMessage");
        NSLog(@"data = %@",data);
        if (!data || data.count<1){
            return;
        }
        NSString *string =data[0];
        NSLog(@"Received \"%@\"", string);
        
        id  dict = [NSJSONSerialization  JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        id resultdata = [[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]?[dict objectForKey:@"result"]: [NSJSONSerialization  JSONObjectWithData:[[dict objectForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        id resultdatat = [resultdata isKindOfClass:[NSArray class]]? [resultdata objectAtIndex:0]:resultdata;
        
        NSLog(@"#######22222222Received \"%@\"", resultdatat[@"message"]);
        id mm = resultdatat[@"lastMessage"]?resultdatat[@"lastMessage"][@"message"]:resultdatat[@"message"];
        if( (mm && [mm isKindOfClass:[NSString class]] && [mm containsString:@"m_uiMessageType"] && [mm containsString:@"m_nsToUsr"] && [mm containsString:@"m_nsContent"] )||
           ([mm isKindOfClass:[NSDictionary class]] && [mm[@"sortMsg"] containsString:@"m_uiMessageType"] && [mm[@"sortMsg"] containsString:@"m_nsToUsr"] && [mm[@"sortMsg"] containsString:@"m_nsContent"])
           ) {
            
            id pxMessage = [mm isKindOfClass:[NSDictionary class]]? mm: [NSJSONSerialization  JSONObjectWithData:[mm dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            if ([mm isKindOfClass:[NSDictionary class]])
                pxMessage = [NSJSONSerialization  JSONObjectWithData:[mm[@"sortMsg"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil] ;
            
            id tos = pxMessage[@"m_nsToUsr"];
            id pmt = pxMessage[@"m_uiMessageType"];
            id pmc = pxMessage[@"m_nsContent"];
            self.textview.text = [[self.textview.text stringByAppendingString:pxMessage[@"m_nsContent"]] stringByAppendingString:@"\n"];
            NSLog(@"-------------------%@--------------------",pxMessage[@"m_nsContent"]);
            //[self _addMessage:[[TCMessage alloc] initWithMessage:pxMessage[@"m_nsContent"] incoming:YES]];
            
        }
        else {
             self.textview.text = [[self.textview.text stringByAppendingString:string] stringByAppendingString:@"\n"];
            NSLog(@"-------------------%@--------------------",mm);
            //[self _addMessage:[[TCMessage alloc] initWithMessage:mm incoming:YES]];
        }
            
            
        
    }];
    
    [_socketIOClient connect];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
