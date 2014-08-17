//
//  MRViewController.m
//  Race to the Top
//
//  Created by Mark Rabins on 7/16/14.
//  Copyright (c) 2014 edu.self.edu. All rights reserved.
//

#import "MRViewController.h"
#import "MRPathView.h"
#import "MRMountainPath.h"

#define RTMAP_STARTING_SCORE 15000
#define RTMAP_SCORE_DECREMENT_AMOUNT 100
#define RTTIMER_INTERVAL 0.1
#define RTWALL_PENALTY 500

@interface MRViewController ()

@property (strong, nonatomic) IBOutlet MRPathView *pathView;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation MRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self.pathView addGestureRecognizer:tapRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.pathView addGestureRecognizer:panRecognizer];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i", RTMAP_STARTING_SCORE];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    CGPoint fingerLocation = [panRecognizer locationInView:self.pathView];
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan && fingerLocation.y < 750)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:RTTIMER_INTERVAL target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i", RTMAP_STARTING_SCORE];
    }
    else if (panRecognizer.state == UIGestureRecognizerStateChanged)
    {
        for (UIBezierPath *path in [MRMountainPath mountainPathsForRect:self.pathView.bounds]){
            UIBezierPath *tapTarget = [MRMountainPath tapTargetForPath:path];
            
            if([tapTarget containsPoint:fingerLocation]){
                [self decrementScoreByAmount:RTWALL_PENALTY];
            }
            
         }
     }
    else if (panRecognizer.state == UIGestureRecognizerStateEnded && fingerLocation.y <= 165 ){
        [self.timer invalidate];
        self.timer = nil;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Make sure to start at the bottom of the path, hold your finger down and finish at the top of the path!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
         [alert show];
        
        [self.timer invalidate];
        self.timer = nil;
    }

}

-(void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    NSLog(@"Tapped!");
    CGPoint tapLocation = [tapRecognizer locationInView:self.pathView];
    NSLog(@"tap location is at (%f, %f)", tapLocation.x, tapLocation.y);
    
}

-(void)timerFired
{
    [self decrementScoreByAmount:RTMAP_SCORE_DECREMENT_AMOUNT];
}

-(void)decrementScoreByAmount:(int)amount
{
    NSString *scoreText = [[self.scoreLabel.text componentsSeparatedByString:@" "] lastObject];
    int score = [scoreText intValue];
    score = score - amount;
    
    NSString *newScoreText = [self.scoreLabel.text stringByReplacingOccurrencesOfString:scoreText withString:[NSString stringWithFormat:@"%i", score]];
    
    self.scoreLabel.text = newScoreText;
    
}

@end
