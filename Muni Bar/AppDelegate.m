//
//  AppDelegate.m
//  Muni Bar
//
//  Created by Andre Torrez on 2/26/13.
//  Copyright (c) 2013 Simpleform. All rights reserved.
//

#import "AppDelegate.h"
#define kEndMinuteSeparator 9

@implementation AppDelegate


- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Loading…"];
    [statusItem setHighlightMode:YES];
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    minuteArray = [[NSMutableArray alloc] init];

    //Refresh data every 60 seconds.
    [NSTimer scheduledTimerWithTimeInterval:60.0
                                     target:self
                                   selector:@selector(loadPredictions:)
                                   userInfo:nil
                                    repeats:YES];

    //Do the first prediction loading.
    [self loadPredictions:nil];
}

-(IBAction)loadPredictions:(id)sender {
    
    NSURL *theURL = [NSURL URLWithString:@"http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=sf-muni&stopId=17355&routeTag=KT"];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:theURL];
    
    [minuteArray removeAllObjects];
    inDesiredDirection = NO;
    
    [parser setDelegate:self];
    [parser parse];
}

/*
 A lot of hardcoded stuff in here.
 For reference: http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=sf-muni&stopId=17355&routeTag=KT
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"direction"] && [[attributeDict objectForKey:@"title"] isEqualToString:@"Outbound to Balboa Park Station via Downtown"]){
        inDesiredDirection = YES;
    }
    
    if ([elementName isEqual:@"prediction"] && inDesiredDirection) {
        [minuteArray addObject:[attributeDict objectForKey:@"minutes"]];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"direction"] && inDesiredDirection){
        inDesiredDirection = NO;

        // Loop through existing menu items and delete anything
        // up to our first separator.
        for (NSMenuItem *item in [statusMenu itemArray]){
            if(item.tag == kEndMinuteSeparator){
                break;
            } else {
                [statusMenu removeItem:item];
            }
        }
        
        for(NSInteger i = 0;i < [minuteArray count]; i++){
            NSMenuItem *item = [statusMenu insertItemWithTitle:[NSString stringWithFormat:@"%@", [minuteArray objectAtIndex:i]] action:nil keyEquivalent:@"" atIndex:i];
            
            //A sort-of hack to not receive a warning about the unused item variable.
            if(i == 0){
                [statusItem setTitle:item.title];
            }
        }
        

    }
}

@end
