//
//  GameOfLifeAppDelegate.h
//  GameOfLife
//
//  Created by Karl Smith on 3/2/11.
//  Copyright 2011 Karl Smith. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GameOfLifeAppDelegate : NSObject /*<NSApplicationDelegate>*/ {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
