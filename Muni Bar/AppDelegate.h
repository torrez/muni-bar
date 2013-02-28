//
//  AppDelegate.h
//  Muni Bar
//
//  Created by Andre Torrez on 2/26/13.
//  Copyright (c) 2013 Simpleform. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate,  NSXMLParserDelegate> {
    IBOutlet NSMenu *statusMenu;
    
    NSStatusItem *statusItem;
    NSMutableArray *minuteArray;
    
    // This is used to determine if I am in the
    // desired (outbound vs. inbound) direction.
    BOOL inDesiredDirection;
}

@property (assign) IBOutlet NSWindow *window;

-(IBAction)loadPredictions:(id)sender;

@end
