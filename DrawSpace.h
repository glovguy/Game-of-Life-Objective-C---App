//
//  DrawSpace.h
//
//  Created by Karl Smith on 3/2/11.
//  Copyright 2011 Karl Smith. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <stdio.h>

const int WindowW = 786;
const int windowH = 531;
const int nSquares = 25.0;
struct vector {
	double x;
	double y;
};


@interface DrawSpace : NSView
{


	IBOutlet id simulationSpeedSlider;
	IBOutlet id spinner;
	IBOutlet id curserRadio;
	IBOutlet id outlineBox;
	IBOutlet id sideToolBar;
	IBOutlet id drawOrToggleText;
	IBOutlet id algorithmRadio;
	
	double xWindow;
	double yWindow;
	double scale;
	double betweenBoxSpacing;
	
	double mouseDownX;
	double mouseDownY;
	double mouseInitialY;
	BOOL drawOrToggle;
	BOOL storedDrawState;
	double windowDifferenceX;
	double windowDifferenceY;
	float zoomSpeed;
	
	
	//  4D Boolian array variables
	
	int xBlocks;
	int yBlocks;
	int blockNumX;
	int blockNumY;
	
	
	//  Hash table variables
	
	int keyCurrent;
	
	NSMutableDictionary *myHash;
	
	enum PIXEL_DATA_ENTRY {XPOSITION, YPOSITION, N1, N2, N3, N4, N5, N6, N7, N8, NUM_NEIGHBORS};		//type == 0, time == 1, etc
	
	//  data is stored in entries in hash table
	//  x position, y position, n1, n2, n3, n4, n5, n6, n7, n8, number of total neighbors
	//  
	
	//   __ __ __
	//  |n1 n2 n3|
	//  |n4    n5|
	//  |n6 n7 n8|
	//   -- -- --
	
	
	BOOL dataStoreArray[10][10][nSquares][nSquares];		//  first number is the number of blocks in the x dimension
														//  second number is for the y dimension, each block is a square with dimensions nSquares
														// 
														//  second number is the x value
														//  third number is the y value
	//int nSquares;
	
	//BOOL 
	
	NSTimer *evolveTimer;
	BOOL evolving;
	int evolveSkipping;
	int shouldEvolve;
}



- (id)initWithFrame:(NSRect)rect;
- (IBAction)awakeFromNib;
- (void)drawRect:(NSRect)rect;

- (IBAction)toggleEvolve:(id)sender;
- (void)evolve:(NSTimer *)Timer;
- (void)computeStep;
- (IBAction)oneStep:(id)sender;
- (IBAction)makeDisplay:(id)sender;

- (IBAction)toggleSideToolBar;


//- (void)mouseOn:(NSEvent *)theEvent;
- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseEntered:(NSEvent *)theEvent;
- (void)mouseExited:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;
//- (void)drawBox:(double)X BoxY:(double)Y;

@end
