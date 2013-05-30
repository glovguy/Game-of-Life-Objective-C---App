//
//  DrawSpace.M
//
//  Created by Karl Smith on 3/2/11.
//  Copyright 2011 Karl Smith. All rights reserved.
//

#import "DrawSpace.h"

@implementation DrawSpace




- (id)initWithFrame:(NSRect)rect
{
	scale = 7.0;					// good value = 14.0
	betweenBoxSpacing = 2.0;		// if scale is 14, good value is 4.0  // or 1.0 when scale is 7.0
	xWindow = 15.0;
	yWindow = 15.0;
	
	
	xBlocks = 10;
	yBlocks = 10;
	
	
	
	evolving = NO;
	
	
	//  {XPOSITION, YPOSITION, N1, N2, N3, N4, N5, N6, N7, N8, NUM_NEIGHBORS}
	keyCurrent = 0;
	myHash = [NSMutableDictionary dictionaryWithCapacity:1];	// get new dictionary; its capacity can expand and shrink
	
	{
	NSValue *key	= [NSNumber numberWithInt:keyCurrent++]; // create data array
	
	NSValue *xposition	= [NSNumber numberWithDouble:6.0];
	NSValue *yposition	= [NSNumber numberWithDouble:6.0];
	
	NSValue *n1		=	[NSNumber numberWithBool:0];
	NSValue *n2		=	[NSNumber numberWithBool:0];
	NSValue *n3		=	[NSNumber numberWithBool:0];
	NSValue *n4		=	[NSNumber numberWithBool:YES];
	NSValue *n5		=	[NSNumber numberWithBool:YES];
	NSValue *n6		=	[NSNumber numberWithBool:0];
	NSValue *n7		=	[NSNumber numberWithBool:0];
	NSValue *n8		=	[NSNumber numberWithBool:0];
	
	NSValue *nNeighbors	=	[NSNumber numberWithInt:2];
		
	
	NSMutableArray *pixel = [NSMutableArray arrayWithObjects: xposition, yposition, n1, n2, n3, n4, n5, n6, n7, n8, nNeighbors, nil];	// value is array of data
	[myHash setObject:pixel forKey:key];	// add to dictionary
	}
	
	
	{
	NSValue *key	= [NSNumber numberWithInt:keyCurrent++]; // create data array
	
	NSValue *xposition	= [NSNumber numberWithDouble:6.0];
	NSValue *yposition	= [NSNumber numberWithDouble:5.0];
	
	NSValue *n1		=	[NSNumber numberWithBool:0];
	NSValue *n2		=	[NSNumber numberWithBool:0];
	NSValue *n3		=	[NSNumber numberWithBool:0];
	NSValue *n4		=	[NSNumber numberWithBool:0];
	NSValue *n5		=	[NSNumber numberWithBool:YES];
	NSValue *n6		=	[NSNumber numberWithBool:0];
	NSValue *n7		=	[NSNumber numberWithBool:0];
	NSValue *n8		=	[NSNumber numberWithBool:0];
	
	NSValue *nNeighbors	=	[NSNumber numberWithInt:1];
	
	
	NSMutableArray *pixel = [NSMutableArray arrayWithObjects: xposition, yposition, n1, n2, n3, n4, n5, n6, n7, n8, nNeighbors, nil];	// value is array of data
	[myHash setObject:pixel forKey:key];	// add to dictionary
	}
	
	
	{
	NSValue *key	= [NSNumber numberWithInt:keyCurrent++]; // create data array
	
	NSValue *xposition	= [NSNumber numberWithDouble:6.0];
	NSValue *yposition	= [NSNumber numberWithDouble:7.0];
	
	NSValue *n1		=	[NSNumber numberWithBool:0];
	NSValue *n2		=	[NSNumber numberWithBool:0];
	NSValue *n3		=	[NSNumber numberWithBool:0];
	NSValue *n4		=	[NSNumber numberWithBool:YES];
	NSValue *n5		=	[NSNumber numberWithBool:0];
	NSValue *n6		=	[NSNumber numberWithBool:0];
	NSValue *n7		=	[NSNumber numberWithBool:0];
	NSValue *n8		=	[NSNumber numberWithBool:0];
	
	NSValue *nNeighbors	=	[NSNumber numberWithInt:1];
	
	
	NSMutableArray *pixel = [NSMutableArray arrayWithObjects: xposition, yposition, n1, n2, n3, n4, n5, n6, n7, n8, nNeighbors, nil];	// value is array of data
	[myHash setObject:pixel forKey:key];	// add to dictionary
	}
	
	
	
	return [super initWithFrame:rect];
}



- (IBAction)awakeFromNib
{
	
	[self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:YES];
	[self addCursorRect:[self bounds] cursor:[NSCursor openHandCursor]];
	[self display];
	
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (IBAction)oneStep:(id)sender
{
	
	
	[self computeStep];
	[self setNeedsDisplay:YES];
}

- (IBAction)toggleEvolve:(id)sender
{
	
	switch (evolving) {
		case NO:
			evolving = YES;
			evolveTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
														   target:self 
														 selector:@selector(evolve:) 
														 userInfo:nil 
														  repeats:YES];
			[spinner startAnimation:nil];
			break;
		default:
			evolving = NO;
			[evolveTimer invalidate];
			[spinner stopAnimation:nil];
			break;
	}
	
	
}


- (void)computeStep		//  this is where the meat of the Game of Life algorithm is
{
	
	int AlgorithmRadioState = [algorithmRadio selectedRow];
	
	if (AlgorithmRadioState == 1)
	{
		
		
		//
		//  test to see if new blocks are needed
		//
		
		BOOL add = NO;
		
		// first, bottom border
		
		for (int TestBlockx=0; (TestBlockx < xBlocks) and (add != YES); TestBlockx++)
		{
			for (int SquareTest=0; (SquareTest < nSquares) and (add != YES); SquareTest++)
			{
				if (dataStoreArray[TestBlockx][0][SquareTest][0] == YES) add = YES;
			}
		}
		
		if (add == YES)
		{
			printf("add\t bottom\n");
		}
		
		add = NO;
		
		// second, left border
		
		for (int TestBlocky=0; (TestBlocky < yBlocks) and (add != YES); TestBlocky++)
		{
			for (int SquareTest=0; (SquareTest < nSquares) and (add != YES); SquareTest++)
			{
				if (dataStoreArray[0][TestBlocky][0][SquareTest] == YES) add = YES;
			}
		}
		
		if (add == YES)
		{
			printf("add\t left\n");
		}
		
		add = NO;
		
		// third, top border
		
		for (int TestBlockx=0; (TestBlockx < xBlocks) and (add != YES); TestBlockx++)
		{
			for (int SquareTest=0; (SquareTest < nSquares) and (add != YES); SquareTest++)
			{
				if (dataStoreArray[TestBlockx][yBlocks-1][SquareTest][nSquares-1] == YES) add = YES;
			}
		}
		
		if (add == YES)
		{
			printf("add\t top\n");
		}
		
		add = NO;
		
		// fourth, right border
		
		for (int TestBlocky=0; (TestBlocky < yBlocks) and (add != YES); TestBlocky++)
		{
			for (int SquareTest=0; (SquareTest < nSquares) and (add != YES); SquareTest++)
			{
				if (dataStoreArray[xBlocks-1][TestBlocky][nSquares-1][SquareTest] == YES) add = YES;
			}
		}
		
		if (add == YES)
		{
			printf("add\t right\n");
		}
		
		
		
		//
		//  code to copy array dataStoreArray to changesDataArray
		//
		
		BOOL changesDataArray[xBlocks][yBlocks][nSquares][nSquares];
		
		for (int i=0; i<xBlocks; i++) {
			for (int j=0; j<yBlocks; j++) {													
				for (int k=0; k<=nSquares; k++) {													
					for (int l=0; l<=nSquares; l++) {												
						changesDataArray[i][j][k][l] = dataStoreArray[i][j][k][l]; } } }		  
		}
		
		
		
		
		
		
		
		//
		//
		//
		
		
		for (int currentBlockx=0; currentBlockx < xBlocks; currentBlockx++)
		{
			for (int currentBlocky=0; currentBlocky < yBlocks; currentBlocky++)
			{
				
				
				
				int Y = 0;
				
				
				for (int X=0; ( (Y != nSquares-1) or (X != nSquares) ); X++)
				{
					
					if (X == nSquares) { Y++;	X = 0;}
					
					
					
					int surroundingLiveSquares = 0;
					
					
					
					
					
					for (float yOffset = -1; yOffset <= 1; yOffset++)
					{
						for (float xOffset = -1; xOffset <= 1; xOffset++)
						{
							
							if ( (xOffset == 0) and (yOffset == 0) ) xOffset = 1;
							
							
							
							int testBlockx = currentBlockx;
							int testBlocky = currentBlocky;
							int testSquarex = int (X+xOffset);
							int testSquarey = int (Y+yOffset);
							BOOL skip = NO;
							
							
							if (X+xOffset < 0)								// test pointer breaks left boundary
							{
								testBlockx = currentBlockx - 1;
								testSquarex = nSquares - 1;
								
								if (!(float (currentBlockx-1) >= 0))
									skip = YES;
								//else printf("breaks left boundary\n");
								
							}
							
							if (X+xOffset >= nSquares)						// test pointer breaks right boundary
							{
								testBlockx = currentBlockx + 1;
								testSquarex = 0;
								
								if (!(float (currentBlockx+1) < xBlocks))
									skip = YES;
								//else printf("breaks right boundary\n");
							}
							
							
							if (Y+yOffset >= nSquares)						// test pointer breaks top boundary
							{
								testBlocky = currentBlocky + 1;
								testSquarey = 0;
								
								if (!(float (currentBlocky+1) < yBlocks))
									skip = YES;
								//else printf("breaks top boundary\n");
							}
							
							if (Y+yOffset < 0)								// test pointer breaks lower boundary
							{
								testBlocky = currentBlocky - 1;
								testSquarey = nSquares - 1;
								
								if (!(float (currentBlocky-1) >= 0))
									skip = YES;
								//else printf("breaks bottom boundary\n");
								
							}
							
							
							
							if (skip == NO)
							{
								if (dataStoreArray[testBlockx][testBlocky][testSquarex][testSquarey]==YES)
									// then
									surroundingLiveSquares++;
							}
							
							
							
						}
					}
					
					
					
					
					if (dataStoreArray[currentBlockx][currentBlocky][X][Y]==NO)
					{
						if (surroundingLiveSquares == 3) changesDataArray[currentBlockx][currentBlocky][X][Y] = YES;
					}
					else {
						if (surroundingLiveSquares < 2) changesDataArray[currentBlockx][currentBlocky][X][Y] = NO;
						if (surroundingLiveSquares > 3) changesDataArray[currentBlockx][currentBlocky][X][Y] = NO;
					}
					
					
					
				}
			}
		}
		
		
		for (int i=0; i<xBlocks; i++) {
			for (int j=0; j<yBlocks; j++) {													
				for (int k=0; k<nSquares; k++) {											//
					for (int l=0; l<nSquares; l++) {										//  code to copy array back into dataStoreArray
						dataStoreArray[i][j][k][l] = changesDataArray[i][j][k][l]; } } }	//  
		}
	}
	
	
	if (AlgorithmRadioState == 0)
	{
		
		
		NSArray *myKeys = [myHash allKeys];
		int totalKeys = [myKeys count];				//  gives total number of entries in dictionary
		//NSArray *myNewKeys = [myHash allKeys];
		//int newTotalKeys = totalKeys;
		
		
		//1. calculate new neighbor data
		for (int focusKey=0; focusKey<=totalKeys-1; focusKey++)
		{
			NSValue *keyU2 = [myKeys objectAtIndex:focusKey]; 
			
			NSMutableArray *pixelU2 = [myHash objectForKey:keyU2];
			double xPosition = [[pixelU2 objectAtIndex:XPOSITION] doubleValue];
			double yPosition = [[pixelU2 objectAtIndex:YPOSITION] doubleValue];
			
			
			
			NSValue *n1 = [NSNumber numberWithBool:NO];
			[pixelU2 insertObject:(id)n1 atIndex:(NSUInteger)N1];
			NSValue *n2 = [NSNumber numberWithBool:NO];
			[pixelU2 insertObject:(id)n2 atIndex:(NSUInteger)N2];
			NSValue *n3 = [NSNumber numberWithBool:NO];
			[pixelU2 insertObject:(id)n3 atIndex:(NSUInteger)N3];
			NSValue *n4 = [NSNumber numberWithBool:NO];
			[pixelU2 insertObject:(id)n4 atIndex:(NSUInteger)N4];
			NSValue *n5 = [NSNumber numberWithBool:NO];
			[pixelU2 insertObject:(id)n5 atIndex:(NSUInteger)N5];
			NSValue *n6 = [NSNumber numberWithBool:NO];
			[pixelU2 insertObject:(id)n6 atIndex:(NSUInteger)N6];
			NSValue *n7 = [NSNumber numberWithBool:NO];
			[pixelU2 insertObject:(id)n7 atIndex:(NSUInteger)N7];
			NSValue *n8 = [NSNumber numberWithBool:NO];
			[pixelU2 insertObject:(id)n8 atIndex:(NSUInteger)N8];
			
			
			
			int neighborsRunningTally = 0;
			BOOL deleted = NO;
			
			for (int testKey=0; testKey<=totalKeys-1 and deleted == NO; testKey++)
			{
				if (testKey != focusKey)
				{
				NSValue *keyU3 = [myKeys objectAtIndex:testKey]; 
				
				NSMutableArray *pixelU3 = [myHash objectForKey:keyU3];
				double testX = [[pixelU3 objectAtIndex:XPOSITION] doubleValue];
				double testY = [[pixelU3 objectAtIndex:YPOSITION] doubleValue];
				
				
				
				
					double xOffset = xPosition-testX;
					double yOffset = yPosition-testY;
				
				
				
					
					
					if (  
						( ((xOffset) <= 1) and ((xOffset) >= -1) ) 
						and ( ((yOffset) <= 1) and ((yOffset) >= -1) )
						)
					{
						
						neighborsRunningTally++;
					
					
					
					if ( (xPosition-1 == testX) and (yPosition+1 == testY) )
					{
																						//   __ __ __
																						//  |n1      |
						NSValue *n1 = [NSNumber numberWithBool:YES];					//  |   ..   |
																						//  |        |
						[pixelU2 insertObject:(id)n1 atIndex:(NSUInteger)N1];			//   -- -- --
						
					}
					
					if ( (xPosition == testX) and (yPosition+1 == testY) )
					{
																						//   __ __ __
																						//  |   n2   |
						NSValue *n2 = [NSNumber numberWithBool:YES];					//  |   ..   |
																						//  |        |
						[pixelU2 insertObject:(id)n2 atIndex:(NSUInteger)N2];			//   -- -- --
						
					}
					
					if ( (xPosition+1 == testX) and (yPosition+1 == testY) )
					{
																						//   __ __ __
																						//  |      n3|
						NSValue *n3 = [NSNumber numberWithBool:YES];					//  |   ..   |
																						//  |        |
						[pixelU2 insertObject:(id)n3 atIndex:(NSUInteger)N3];			//   -- -- --
						
					}
					
					if ( (xPosition-1 == testX) and (yPosition == testY) )
					{
																						//   __ __ __
																						//  |        |
						NSValue *n4 = [NSNumber numberWithBool:YES];					//  |n4 ..   |
																						//  |        |
						[pixelU2 insertObject:(id)n4 atIndex:(NSUInteger)N4];			//   -- -- --
						
					}
						
					if ( (xPosition+1 == testX) and (yPosition == testY) )
					{
																						//   __ __ __
																						//  |        |
						NSValue *n5 = [NSNumber numberWithBool:YES];					//  |   .. n5|
																						//  |        |
						[pixelU2 insertObject:(id)n5 atIndex:(NSUInteger)N5];			//   -- -- --
						
					}
					
					if ( (xPosition-1 == testX) and (yPosition-1 == testY) )
					{
																						//   __ __ __
																						//  |        |
						NSValue *n6 = [NSNumber numberWithBool:YES];					//  |   ..   |
																						//  |n6      |
						[pixelU2 insertObject:(id)n6 atIndex:(NSUInteger)N6];			//   -- -- --
						
					}
					
					if ( (xPosition == testX) and (yPosition-1 == testY) )
					{
																						//   __ __ __
																						//  |        |
						NSValue *n7 = [NSNumber numberWithBool:YES];					//  |   ..   |
																						//  |   n7   |
						[pixelU2 insertObject:(id)n7 atIndex:(NSUInteger)N7];			//   -- -- --
						
					}
					
					if ( (xPosition+1 == testX) and (yPosition-1 == testY) )
					{
																						//   __ __ __
																						//  |        |
						NSValue *n8 = [NSNumber numberWithBool:YES];					//  |   ..   |
																						//  |      n8|
						[pixelU2 insertObject:(id)n8 atIndex:(NSUInteger)N8];			//   -- -- --
						
					}
						
						
						/*
						if ( (xPosition-1 == testX) and (yPosition == testY) )
						{
																							//   __ __ __
							printf("error: doubled pixel. Deleting...\n");					//  |        |
																							//  |   xx   |
							[myHash removeObjectForKey:keyU2];								//  |        |
							deleted = YES;													//   -- -- --
							
						}*/
					
				}
				}
			}
			
			
			if (deleted == NO)
			{
				NSValue *nNeighbors	= [NSNumber numberWithInt:neighborsRunningTally];
				[pixelU2 insertObject:(id)nNeighbors atIndex:(NSUInteger)NUM_NEIGHBORS];
				
				
				
				int display1 = [[pixelU2 objectAtIndex:N1] boolValue];
				int display2 = [[pixelU2 objectAtIndex:N2] boolValue];
				int display3 = [[pixelU2 objectAtIndex:N3] boolValue];
				int display4 = [[pixelU2 objectAtIndex:N4] boolValue];
				int display5 = [[pixelU2 objectAtIndex:N5] boolValue];
				int display6 = [[pixelU2 objectAtIndex:N6] boolValue];
				int display7 = [[pixelU2 objectAtIndex:N7] boolValue];
				int display8 = [[pixelU2 objectAtIndex:N8] boolValue];
				
				printf("%lf\t%lf\t%i\t%i\t%i\t%i\t%i\t%i\t%i\t%i\n",xPosition,yPosition,display1,display2,display3,display4,display5,display6,display7,display8);
				
			}
			
			
			
		}
		
		
		
		
		
		
		
		//3. test dead cells, add any reanimated ones to the dictionary
		//int newKeyCurrent = 0;
		//NSMutableDictionary *myNewHash = [NSMutableDictionary dictionaryWithCapacity:1];	// get new dictionary; its capacity can expand and shrink
		for (int focusKey=0; focusKey<=totalKeys-1; focusKey++)
		{
			NSValue *keyU2 = [myKeys objectAtIndex:focusKey]; 
			
			NSMutableArray *pixelU2 = [myHash objectForKey:keyU2];
			
			if ([[pixelU2 objectAtIndex:NUM_NEIGHBORS] intValue] != 9)
			{
			for (int n=N1; n<N8; n++)
			{
				if ([[pixelU2 objectAtIndex:n] boolValue] == NO)
				{
					double xPosition = [[pixelU2 objectAtIndex:XPOSITION] doubleValue];
					double yPosition = [[pixelU2 objectAtIndex:YPOSITION] doubleValue];
					
					double deadX;
					double deadY;
					
					{
					if (n == N1)
					{
						deadX = xPosition - 1;
						deadY = yPosition + 1;
					}
					
					if (n == N2)
					{
						deadX = xPosition;
						deadY = yPosition + 1;
					}
					
					if (n == N3)
					{
						deadX = xPosition + 1;
						deadY = yPosition + 1;
					}
					
					if (n == N4)
					{
						deadX = xPosition - 1;
						deadY = yPosition;
					}
					
					if (n == N5)
					{
						deadX = xPosition + 1;
						deadY = yPosition;
					}
					
					if (n == N6)
					{
						deadX = xPosition - 1;
						deadY = yPosition - 1;
					}
					
					if (n == N7)
					{
						deadX = xPosition;
						deadY = yPosition - 1;
					}
					
					if (n == N8)
					{
						deadX = xPosition + 1;
						deadY = yPosition - 1;
					}
					}
					
					
					
					
					
					int neighborsRunningTally = 0;
					BOOL skipThisOne = NO;
					
					
					
					
					for (int probeKey=0; probeKey<=totalKeys-1 and skipThisOne == NO; probeKey++)
					{
						
						
						NSValue *keyU4 = [myKeys objectAtIndex:probeKey]; 
						
						NSMutableArray *pixelU4 = [myHash objectForKey:keyU4];
						
						if ([[pixelU4 objectAtIndex:NUM_NEIGHBORS] intValue] != 9)
						{
						
						double testX = [[pixelU4 objectAtIndex:XPOSITION] doubleValue];
						double testY = [[pixelU4 objectAtIndex:YPOSITION] doubleValue];
						
						
						if ( (testX == deadX) and (testY == deadY) )
						{
							skipThisOne = YES;
						}
						
						if (  
							( ((testX-deadX) <= 1) and ((testX-deadX) >= -1) ) 
							and 
							( ((testY-deadY) <= 1) and ((testY-deadY) >= -1) )
							)
						{
							neighborsRunningTally++;
							
							/*
							{
								if ( (deadX-1 == testX) and (deadY+1 == testY) )
								{
									n1 = [NSNumber numberWithBool:YES];
									//   __ __ __
									//  |n1      |
									//  |   ..   |
									//  |        |
									//   -- -- --
								}
								
								if ( (deadX == testX) and (deadY+1 == testY) )
								{
									n2 = [NSNumber numberWithBool:YES];
									//   __ __ __
									//  |   n2   |
									//  |   ..   |
									//  |        |
									//   -- -- --
								}
								
								if ( (deadX+1 == testX) and (deadY+1 == testY) )
								{
									n3 = [NSNumber numberWithBool:YES];								
									//   __ __ __
									//  |      n3|
									//  |   ..   |
									//  |        |
									//   -- -- --
								}
								
								if ( (deadX-1 == testX) and (deadY == testY) )
								{
									n4 = [NSNumber numberWithBool:YES];
									//   __ __ __
									//  |        |
									//  |n4 ..   |
									//  |        |
									//   -- -- --
								}
								
								if ( (deadX+1 == testX) and (deadY == testY) )
								{
									n5 = [NSNumber numberWithBool:YES];
									//   __ __ __
									//  |        |
									//  |   .. n5|
									//  |        |
									//   -- -- --
								}
								
								if ( (deadX-1 == testX) and (deadY-1 == testY) )
								{
									n6 = [NSNumber numberWithBool:YES];
									//   __ __ __
									//  |        |
									//  |   ..   |
									//  |n6      |
									//   -- -- --
								}
								
								if ( (deadX == testX) and (deadY-1 == testY) )
								{
									n7 = [NSNumber numberWithBool:YES];
									//   __ __ __
									//  |        |
									//  |   ..   |
									//  |   n7   |
									//   -- -- --
								}
								
								if ( (deadX+1 == testX) and (deadY-1 == testY) )
								{
									n8 = [NSNumber numberWithBool:YES];
									//   __ __ __
									//  |        |
									//  |   ..   |
									//  |      n8|
									//   -- -- --
								}
							}*/
							
							
						}
						}
						
					}
					
					
					if ( (neighborsRunningTally == 3) and (skipThisOne == NO) )
					{
						
						
						for (int doubleCheck=0; (doubleCheck <= totalKeys-1) and (skipThisOne == NO); doubleCheck++)
						{
							
							
							
							NSValue *keyU6 = [myKeys objectAtIndex:doubleCheck]; 
							
							NSMutableArray *pixelU6 = [myHash objectForKey:keyU6];
							double doubleCheckX = [[pixelU6 objectAtIndex:XPOSITION] doubleValue];
							double doubleCheckY = [[pixelU6 objectAtIndex:YPOSITION] doubleValue];
							
							
							
							if ( (doubleCheckX == deadX) and (doubleCheckY == deadY) )
							{
								skipThisOne = YES;
							}
							
						}
						
						if (skipThisOne == NO)
						{
							
							
							
							NSValue *thisKey	= [NSNumber numberWithInt:keyCurrent++]; // create data array
							
							NSValue *n1 = [NSNumber numberWithBool:YES];
							NSValue *n2 = [NSNumber numberWithBool:YES];
							NSValue *n3 = [NSNumber numberWithBool:YES];
							NSValue *n4 = [NSNumber numberWithBool:YES];
							NSValue *n5 = [NSNumber numberWithBool:YES];
							NSValue *n6 = [NSNumber numberWithBool:YES];
							NSValue *n7 = [NSNumber numberWithBool:YES];
							NSValue *n8 = [NSNumber numberWithBool:YES];
							
							NSValue *thisXposition	= [NSNumber numberWithDouble:deadX];
							NSValue *thisYposition	= [NSNumber numberWithDouble:deadY];
							
							NSValue *nNeighbors	= [NSNumber numberWithInt:9];
							
							printf("animate pixel at:%lf\t%lf\n\tfrom perspective pixel:%lf\t%lf\n",deadX,deadY,xPosition,yPosition);
							
							
							NSMutableArray *thisPixel = [NSMutableArray arrayWithObjects: thisXposition, thisYposition, n1, n2, n3, n4, n5, n6, n7, n8, nNeighbors, nil];	// value is array of data
							[myHash setObject:thisPixel forKey:thisKey];	// add to dictionary
							
							totalKeys++;
							myKeys = [myHash allKeys];
						}
						
					}
					
					
					
					
				}
				
			}
			
			}
			
		}
		
		
		
		//2. kill cells that need dying
		for (int focusKey=0; focusKey<=totalKeys-1; focusKey++)
		{
			NSValue *keyU2 = [myKeys objectAtIndex:focusKey]; 
			
			NSMutableArray *pixelU2 = [myHash objectForKey:keyU2];
			int PixelsNeighbors = [[pixelU2 objectAtIndex:NUM_NEIGHBORS] intValue];
			
			if ( (PixelsNeighbors < 2) or (PixelsNeighbors > 3) and (PixelsNeighbors != 9) )
			{
				double X = [[pixelU2 objectAtIndex:XPOSITION] doubleValue];
				double Y = [[pixelU2 objectAtIndex:YPOSITION] doubleValue];
				printf("killed pixel at:%lf\t%lf\n",X,Y);
				
				[myHash removeObjectForKey:keyU2];
				
			}
			
		}
		
		
		
	}
	
}

- (void)evolve:(NSTimer *)Timer
{
	
	evolveSkipping = [simulationSpeedSlider intValue];
	
	if (shouldEvolve < 300)
	{
		shouldEvolve = shouldEvolve + evolveSkipping;
	}
	else
	{
		shouldEvolve = evolveSkipping;
		
		
		[self computeStep];
		
		[self setNeedsDisplay:YES];
	}
	
	
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -


- (IBAction)makeDisplay:(id)sender
{
	
	[self display];			//  this method does exactly what it sounds like
}



- (void)drawRect:(NSRect)rect
{
	
	//
	//  this draws the background
	//
	
	[[NSColor colorWithCalibratedRed:0.1 green:0.1 blue:0.1 alpha:1.0] set];
	NSRectFill([self bounds]);
	
	
	
	
	int AlgorithmRadioState = [algorithmRadio selectedRow];
	
	
	// 4D Boolean Array Display
	if (AlgorithmRadioState == 1)
	{
		
		//
		//  this code draws each "pixel" for the array algorithm
		//
		
		
		for (int blockTesty=0; blockTesty<yBlocks; blockTesty++)
		{
			for (int blockTestx=0; blockTestx<xBlocks; blockTestx++)
			{
				
				
				int Y = 0;
				for (int X=0; (Y<=nSquares-2 or X<=nSquares-1); X++)
				{
					
					
					if (X == nSquares) { Y++;	X = 0;}
					if (dataStoreArray[blockTestx][blockTesty][X][Y] == YES)
					{
						
						[[NSColor colorWithCalibratedRed:0.1 green:1.0 blue:0.1 alpha:1.0] set];
						NSBezierPath *box = [NSBezierPath bezierPath];
						
						[box moveToPoint:NSMakePoint(( (blockTestx * nSquares) + X+xWindow		)*scale,						( (blockTesty * nSquares) + Y+yWindow)		*scale)];
						[box lineToPoint:NSMakePoint(( (blockTestx * nSquares) + X+xWindow+1	)*scale-betweenBoxSpacing,		( (blockTesty * nSquares) + Y+yWindow)		*scale)];
						[box lineToPoint:NSMakePoint(( (blockTestx * nSquares) + X+xWindow+1	)*scale-betweenBoxSpacing,		( (blockTesty * nSquares) + Y+yWindow+1)	*scale-betweenBoxSpacing)];
						[box lineToPoint:NSMakePoint(( (blockTestx * nSquares) + X+xWindow		)*scale,						( (blockTesty * nSquares) + Y+yWindow+1)	*scale-betweenBoxSpacing)];
						[box fill];
						
					}
				}
				
				
				
			}
		}
		
		
		
			//
			//  This code outlines the boxes in the array algorithm
			//
		
		if ([outlineBox state] == TRUE)
		{
			
			
			[[NSColor colorWithCalibratedRed:1.0 green:0.0 blue:0.1 alpha:0.7] set];
			
			int scrollBlocky = 0;
			for (int displayBlockx = 0; scrollBlocky < yBlocks; displayBlockx++)
			{
				
				if (displayBlockx == xBlocks)
				{
					
					displayBlockx = 0;
					scrollBlocky++;
				}
				
				if (scrollBlocky < yBlocks)
				{
					NSBezierPath *outline = [NSBezierPath bezierPath];
					
					[outline moveToPoint:NSMakePoint( (				xWindow  + ((displayBlockx)*nSquares) ) *scale,	(				yWindow + ((scrollBlocky)*nSquares))	*scale)];
					[outline lineToPoint:NSMakePoint( ( nSquares +	xWindow  + ((displayBlockx)*nSquares) ) *scale,	(				yWindow + ((scrollBlocky)*nSquares))	*scale)];
					[outline lineToPoint:NSMakePoint( ( nSquares +	xWindow  + ((displayBlockx)*nSquares) ) *scale,	( nSquares +	yWindow + ((scrollBlocky)*nSquares))	*scale)];
					[outline lineToPoint:NSMakePoint( (				xWindow	 + ((displayBlockx)*nSquares) ) *scale,	( nSquares +	yWindow + ((scrollBlocky)*nSquares))	*scale)];
					[outline lineToPoint:NSMakePoint( (				xWindow	 + ((displayBlockx)*nSquares) ) *scale,	(				yWindow + ((scrollBlocky)*nSquares))	*scale)];
					[outline stroke];
				}
				
			}
		}
		
	}
	
	// Hash Table Display
	if (AlgorithmRadioState == 0)
	{
		
		//
		//  this is the draw code for the NSMutableDictionary algorithm
		//
		
		NSArray *myKeys = [myHash allKeys];
		int totalKeys = [myKeys count];				//  gives total number of entries in dictionary
		printf("totalKeys:%i\n",totalKeys);
		
		//printf("%i\n",totalKeys);
		for (int drawnKey=0; drawnKey<=totalKeys-1; drawnKey++)
		{
			printf("drawnKey:%i\t",drawnKey);
			NSValue *keyU2 = [myKeys objectAtIndex:drawnKey]; 
			
			NSMutableArray *pixelU2 = [myHash objectForKey:keyU2];
			double X = [[pixelU2 objectAtIndex:XPOSITION] doubleValue];
			double Y = [[pixelU2 objectAtIndex:YPOSITION] doubleValue];
			
			printf("X:%lf\tY:%lf\n",X,Y);
			
			[[NSColor colorWithCalibratedRed:0.1 green:1.0 blue:0.1 alpha:1.0] set];
			NSBezierPath *box = [NSBezierPath bezierPath];
			
			[box moveToPoint:NSMakePoint(( X+xWindow		)*scale,						( Y+yWindow)		*scale)];
			[box lineToPoint:NSMakePoint(( X+xWindow+1		)*scale-betweenBoxSpacing,		( Y+yWindow)		*scale)];
			[box lineToPoint:NSMakePoint(( X+xWindow+1		)*scale-betweenBoxSpacing,		( Y+yWindow+1)		*scale-betweenBoxSpacing)];
			[box lineToPoint:NSMakePoint(( X+xWindow		)*scale,						( Y+yWindow+1)		*scale-betweenBoxSpacing)];
			[box fill];
			
		}			
		
	}
	
	
	
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -


- (void)mouseDown:(NSEvent *)theEvent
{
	
	int RadioState = [curserRadio selectedRow];
	
	NSPoint downInWindow = [theEvent locationInWindow];
	NSPoint downInView = [self convertPoint:downInWindow fromView:nil];
	
	
	if (RadioState == 0)	// edit mode
	{
		
		
		int AlgorithmRadioState = [algorithmRadio selectedRow];
		
		if (AlgorithmRadioState == 1)			//  drawing for 4D boolean array algorithm
		{
			
			int currentBlocky = 0;
			int currentBlockx = 0;
			
			currentBlockx = (downInView.x / scale - xWindow) / nSquares;
			currentBlocky = (downInView.y / scale - yWindow) / nSquares;
			
			
			//  **
			//  Some code needed here for creating new blocks when user draws new data outside of current blocks
			
			
			if (currentBlockx < 0) {
				//currentBlockx = 0;
				
			}
			
			/*
			 if (currentBlocky < 0) {
			 currentBlocky = 0;
			 }
			 */
			
			int boxPressedx = (downInView.x / scale - xWindow) - currentBlockx * nSquares;
			int boxPressedy = (downInView.y / scale - yWindow) - currentBlocky * nSquares;
			
			if (dataStoreArray[currentBlockx][currentBlocky][boxPressedx][boxPressedy]) 
			{
				dataStoreArray[currentBlockx][currentBlocky][boxPressedx][boxPressedy] = NO;
				storedDrawState = NO;
			}
			else
			{
				dataStoreArray[currentBlockx][currentBlocky][boxPressedx][boxPressedy] = YES;
				storedDrawState = YES;
			}
			
		}
		
		
		
		if (AlgorithmRadioState == 0)		//  drawing for hashtable algorithm
		{
			
			NSArray *myKeys = [myHash allKeys];
			int totalKeys = [myKeys count];				//  gives total number of entries in dictionary
			
			
			int currentPixelx = (downInView.x / scale - xWindow);
			int currentPixely = (downInView.y / scale - yWindow);
			
			BOOL skip = NO;
			
			for (int focusKey=0; focusKey<=totalKeys-1 and skip == NO; focusKey++)
			{
				NSValue *keyU7 = [myKeys objectAtIndex:focusKey]; 
				
				NSMutableArray *pixelU7 = [myHash objectForKey:keyU7];
				
				double X = [[pixelU7 objectAtIndex:XPOSITION] doubleValue];
				double Y = [[pixelU7 objectAtIndex:YPOSITION] doubleValue];
				
				
				
				if ( (X == currentPixelx) and (Y == currentPixely) )
				{
					skip = YES;
					
					printf("undraw pixel at:%i\t%i\n",currentPixelx,currentPixely);
					[myHash removeObjectForKey:keyU7];
					
				}
				
				
				
			}
			
			
			if (skip == NO) 
			{
				
				NSValue *thisKey	= [NSNumber numberWithInt:keyCurrent++]; // create data array
				
				NSValue *thisXposition	= [NSNumber numberWithDouble:currentPixelx];
				NSValue *thisYposition	= [NSNumber numberWithDouble:currentPixely];
				
				NSValue *n1		=	[NSNumber numberWithBool:0];
				NSValue *n2		=	[NSNumber numberWithBool:0];
				NSValue *n3		=	[NSNumber numberWithBool:0];
				NSValue *n4		=	[NSNumber numberWithBool:YES];
				NSValue *n5		=	[NSNumber numberWithBool:0];
				NSValue *n6		=	[NSNumber numberWithBool:0];
				NSValue *n7		=	[NSNumber numberWithBool:0];
				NSValue *n8		=	[NSNumber numberWithBool:0];
				
				NSValue *nNeighbors	=	[NSNumber numberWithInt:1];
				
				printf("draw pixel at:%i\t%i\n",currentPixelx,currentPixely);
				
				
				NSMutableArray *thisPixel = [NSMutableArray arrayWithObjects: thisXposition, thisYposition, n1, n2, n3, n4, n5, n6, n7, n8, nNeighbors, nil];	// value is array of data
				[myHash setObject:thisPixel forKey:thisKey];	// add to dictionary
				
			}
			
			
			
		}
		
		[self display];
	}	
	
	
	if (RadioState == 1)	// move hand
	{
		[[NSCursor closedHandCursor] set];
		
		mouseDownX = downInView.x;
		mouseDownY = downInView.y;
	}
	
	
	if (RadioState == 2)	// zoom
	{
		mouseDownX = downInView.x;
		mouseDownY = mouseInitialY = downInView.y;
		
		zoomSpeed = 0.4*(1/(scale+0.7));
		
		windowDifferenceX = downInView.x / scale - xWindow;
		windowDifferenceY = downInView.y / scale - yWindow;
	}
	
	
	
	
	

}



- (void)mouseDragged:(NSEvent *)theEvent
{
	int RadioState = [curserRadio selectedRow];
	
	NSPoint downInWindow = [theEvent locationInWindow];
	NSPoint downInView = [self convertPoint:downInWindow fromView:nil];
	
	
	if (RadioState == 0)
	{
		// edit mode
		
		int AlgorithmRadioState = [algorithmRadio selectedRow];
		
		if (AlgorithmRadioState == 1)			//  drawing for 4D boolean array algorithm
		{
		
		int currentBlocky = 0;
		int currentBlockx = 0;
		
		
		
		currentBlockx = (downInView.x / scale - xWindow) / nSquares;
		currentBlocky = (downInView.y / scale - yWindow) / nSquares;
		
		
		//  **
		//  Some code needed here for creating new blocks when user draws new data outside of current blocks
		
		
		if (currentBlockx < 0) {
			//currentBlockx = 0;
			
		}
		
		/*
		 if (currentBlocky < 0) {
		 currentBlocky = 0;
		 }
		 */
		
		int boxPressedx = (downInView.x / scale - xWindow) - currentBlockx * nSquares;
		int boxPressedy = (downInView.y / scale - yWindow) - currentBlocky * nSquares;
		
		switch (drawOrToggle)
		{
			case YES:
				if (dataStoreArray[currentBlockx][currentBlocky][boxPressedx][boxPressedy]) 
					// then
				{dataStoreArray[currentBlockx][currentBlocky][boxPressedx][boxPressedy] = NO;}
				else {dataStoreArray[currentBlockx][currentBlocky][boxPressedx][boxPressedy] = YES;}
				break;
				
			default:
				dataStoreArray[currentBlockx][currentBlocky][boxPressedx][boxPressedy] = storedDrawState;
				break;
		}
		}
		
		
		if (AlgorithmRadioState == 0)			//  drawing for 4D boolean array algorithm
		{
			
			NSArray *myKeys = [myHash allKeys];
			int totalKeys = [myKeys count];				//  gives total number of entries in dictionary
			
			
			int currentPixelx = (downInView.x / scale - xWindow);
			int currentPixely = (downInView.y / scale - yWindow);
			
			BOOL skip = NO;
			
			for (int focusKey=0; focusKey<=totalKeys-1 and skip == NO; focusKey++)
			{
				NSValue *keyU7 = [myKeys objectAtIndex:focusKey]; 
				
				NSMutableArray *pixelU7 = [myHash objectForKey:keyU7];
				
				double X = [[pixelU7 objectAtIndex:XPOSITION] doubleValue];
				double Y = [[pixelU7 objectAtIndex:YPOSITION] doubleValue];
				
				
				
				if ( (X == currentPixelx) and (Y == currentPixely) )
				{
					skip = YES;
					
					printf("undraw pixel at:%i\t%i\n",currentPixelx,currentPixely);
					if (drawOrToggle == NO)
					{
					if (storedDrawState == YES)
					{
							[myHash removeObjectForKey:keyU7];
					}
						else
						{
							NSValue *thisKey	= [NSNumber numberWithInt:keyCurrent++]; // create data array
							
							NSValue *thisXposition	= [NSNumber numberWithDouble:currentPixelx];
							NSValue *thisYposition	= [NSNumber numberWithDouble:currentPixely];
							
							NSValue *n1		=	[NSNumber numberWithBool:0];
							NSValue *n2		=	[NSNumber numberWithBool:0];
							NSValue *n3		=	[NSNumber numberWithBool:0];
							NSValue *n4		=	[NSNumber numberWithBool:YES];
							NSValue *n5		=	[NSNumber numberWithBool:0];
							NSValue *n6		=	[NSNumber numberWithBool:0];
							NSValue *n7		=	[NSNumber numberWithBool:0];
							NSValue *n8		=	[NSNumber numberWithBool:0];
							
							NSValue *nNeighbors	=	[NSNumber numberWithInt:1];
							
							printf("draw pixel at:%i\t%i\n",currentPixelx,currentPixely);
							
							
							NSMutableArray *thisPixel = [NSMutableArray arrayWithObjects: thisXposition, thisYposition, n1, n2, n3, n4, n5, n6, n7, n8, nNeighbors, nil];	// value is array of data
							[myHash setObject:thisPixel forKey:thisKey];	// add to dictionary
						}

						}
					else
					{
						[myHash removeObjectForKey:keyU7];
					}

					
					
					
				}
				
				
				
			}
			
			
			if (skip == NO) 
			{
				
				NSValue *thisKey	= [NSNumber numberWithInt:keyCurrent++]; // create data array
				
				NSValue *thisXposition	= [NSNumber numberWithDouble:currentPixelx];
				NSValue *thisYposition	= [NSNumber numberWithDouble:currentPixely];
				
				NSValue *n1		=	[NSNumber numberWithBool:0];
				NSValue *n2		=	[NSNumber numberWithBool:0];
				NSValue *n3		=	[NSNumber numberWithBool:0];
				NSValue *n4		=	[NSNumber numberWithBool:YES];
				NSValue *n5		=	[NSNumber numberWithBool:0];
				NSValue *n6		=	[NSNumber numberWithBool:0];
				NSValue *n7		=	[NSNumber numberWithBool:0];
				NSValue *n8		=	[NSNumber numberWithBool:0];
				
				NSValue *nNeighbors	=	[NSNumber numberWithInt:1];
				
				printf("draw pixel at:%i\t%i\n",currentPixelx,currentPixely);
				
				
				NSMutableArray *thisPixel = [NSMutableArray arrayWithObjects: thisXposition, thisYposition, n1, n2, n3, n4, n5, n6, n7, n8, nNeighbors, nil];	// value is array of data
				[myHash setObject:thisPixel forKey:thisKey];	// add to dictionary
				
			}
		}
		
		[self display];
	}	
	
	
	if (RadioState == 1)
	{
		
		xWindow = (downInView.x - mouseDownX) / scale + xWindow;
		mouseDownX = downInView.x;
		yWindow = (downInView.y - mouseDownY) / scale + yWindow;
		mouseDownY = downInView.y;
		
		[self setNeedsDisplay:YES];
	}
	
	
	if (RadioState == 2)
	{
		printf("xWindow=%lf\n",xWindow);
		
		
		
		scale = (scale + zoomSpeed * (downInView.y - mouseDownY));
		if (scale < 1.0)
			scale = 1.0;
		betweenBoxSpacing = (2.0/7.0) * scale;
		
		xWindow = (1/scale) * mouseDownX - windowDifferenceX;
		yWindow = (1/scale) * mouseInitialY - windowDifferenceY;
		
		
		mouseDownY = downInView.y;
		zoomSpeed = 0.4*(1/(scale+0.7));
		if (zoomSpeed < 0.035)
			//then
			zoomSpeed = 0.035;
		
		
		[self setNeedsDisplay:YES];
	}
}



- (void)mouseEntered:(NSEvent *)theEvent
{
	
	switch ([curserRadio selectedRow])
	{
		case 0:
			drawOrToggle = [drawOrToggleText state];
			break;
		case 1:
			[[NSCursor openHandCursor] set];
			break;
		default:
			//[[NSCursor magnifierHandCursor] set];
			break;
			

	}
	
	
	
}



- (void)mouseExited:(NSEvent *)theEvent
{
	
	[[NSCursor arrowCursor] set];
	
	
}



- (void)mouseUp:(NSEvent *)theEvent
{
	int RadioState = [curserRadio selectedRow];
	
	if ( ([self mouse:[theEvent locationInWindow] inRect:[self frame]]) and (RadioState == 1) ) [[NSCursor openHandCursor] set];
	else [[NSCursor arrowCursor] set];
	
	
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -


- (IBAction)toggleSideToolBar
{
	
	[sideToolBar orderFront:sideToolBar];
	
	
}
@end
