//
//  SnSSmartPlayerController.h
//  RichMorningShow-iPad
//
//  Created by Julien Di Marco on 24/07/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

# pragma mark Local Symbol definition

@protocol SnSSmartPlayerDelegate <NSObject>
@optional

- (void) smartPlayerDidReachEnd;

@end

@interface SnSSmartPlayerController : UIViewController
{
    // Views Containers
    
    IBOutletCollection(UIButton) NSMutableArray *playButtons_;
    IBOutletCollection(UIButton) NSMutableArray *pauseButtons_;
    IBOutletCollection(UIButton) NSMutableArray *stopButtons_;
    
    IBOutletCollection(UISlider) NSMutableArray *volumeSliders_;
    IBOutletCollection(UISlider) NSMutableArray *scrubberSliders_;
    
    IBOutletCollection(id)       NSMutableArray *subAreas_;
    IBOutletCollection(UIView)   NSMutableArray *playerViews_;

    id <SnSSmartPlayerDelegate> delegate_;
    
    // Utilities
    
    BOOL isPreparedToPlay_;
    BOOL enabled_;
    
    NSURL *contentURL_;
    
    NSArray *subtitles_;
    
    NSArray *subtitlesTexts_;
    NSArray *subtitlesTimes_;
    // AVFoundation logics

@private
    float   restoreAfterScrubbingRate_;
	BOOL    seekToZeroBeforePlay_;

    id      scrubbersTimeObserver_; // MUST removeObserver before release
    
    AVPlayer        *player_;
    AVURLAsset      *urlAsset_;
    AVPlayerItem    *currentItem_;
    
    CMTime          itemDuration_;
    
    CAKeyframeAnimation *subtitlesAnimation_;
}

# pragma mark Property definition

// Views Containers

@property (nonatomic, retain, readonly) NSArray *playButtons;
@property (nonatomic, retain, readonly) NSArray *pauseButtons;
@property (nonatomic, retain, readonly) NSArray *stopButtons;

@property (nonatomic, retain, readonly) NSArray *volumeSliders;
@property (nonatomic, retain, readonly) NSArray *scrubberSliders;

@property (nonatomic, retain, readonly) NSArray *subAreas;
@property (nonatomic, retain, readonly) NSArray *playerViews;

@property (nonatomic, assign) id <SnSSmartPlayerDelegate> delegate;

// Utilities

@property (nonatomic, assign, readonly) BOOL isPreparedToPlay;
@property (nonatomic,assign) BOOL enabled;

@property (nonatomic, assign) NSURL *contentURL;

@property (nonatomic, retain) NSArray *subtitles;

@property (nonatomic, retain, readonly) NSArray *subtitlesTexts;
@property (nonatomic, retain, readonly) NSArray *subtitlesTimes;

// AVFoundation logics

@property (nonatomic, retain, readonly) id scrubbersTimeObserver;

@property (nonatomic, retain, readonly) AVPlayer        *player;
@property (nonatomic, retain, readonly) AVURLAsset      *urlAsset;
@property (nonatomic, retain, readonly) AVPlayerItem    *currentItem;

@property (nonatomic, assign, readonly) CMTime          itemDuration;

@property (nonatomic, retain, readonly) CAKeyframeAnimation *subtitlesAnimation;

# pragma mark -
# pragma mark Methods definition
# pragma mark -

# pragma mark Initializers

- (id)initWithContentURL:(NSURL *)url nibName:(NSString *)name; // Designated Initializer
- (id)initWithContentURL:(NSURL *)url;

+ (id)resourceNamed:(NSString *)name withExtension:(NSString *)extension;

# pragma mark MPMediaPlayback Protocol
// MPMediaPlayback Protocol implementation

- (IBAction)play;
- (IBAction)pause;
- (IBAction)stop;
- (void)prepareToPlay;
- (void)shutdown;

- (IBAction)beginSeekingBackward;
- (IBAction)beginSeekingForward;
- (void)endSeeking;

# pragma mark Add Button/Slider/Views

- (void)addPlayButton:(UIButton*)button;
- (void)addPauseButton:(UIButton*)button;
- (void)addStopButton:(UIButton*)button;
- (void)addVolumeSlider:(UISlider*)slider;
- (void)addScrubber:(UISlider*)slider;
- (void)addSubArea:(UILabel*)subArea;
- (void)addPlayerView:(UIView*)playerView;

# pragma mark Events

- (IBAction)beginScrubbing:(id)sender;
- (IBAction)scrub:(UISlider*)sender;
- (IBAction)endScrubbing:(id)sender;
- (IBAction)volumeChanged:(UISlider *)sender;

@end
