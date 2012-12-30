//
//  SnSSmartPlayerController.m
//  RichMorningShow-iPad
//
//  Created by Julien Di Marco on 24/07/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "SnSSmartPlayerController.h"

#import "SnSSmartPlayerView.h"
#import "SnSSmartSubtitleView.h"

// Asset keys
NSString * const kSPTracksKey       = @"tracks";
NSString * const kSPPlayableKey     = @"playable";

// PlayerItem keys
NSString * const kSPStatusKey       = @"status";
NSString * const kSPLoadedTimeRangesKey   = @"loadedTimeRanges";

// AVPlayer keys
NSString * const kSPRateKey			= @"rate";
NSString * const kSPCurrentItemKey	= @"currentItem";


// KVO contexts

# pragma mark KVO - Observation contexts

static void *SPCurrentItemObservationContext = &SPCurrentItemObservationContext;
static void *SPStatusObservationContext = &SPStatusObservationContext;
static void *SPRateObservationContext = &SPRateObservationContext;
static void *SPLayerReadyForDisplay = &SPLayerReadyForDisplay;
static void *SPBufferingObservationContext = &SPBufferingObservationContext;

#pragma mark reDefined Property

@interface SnSSmartPlayerController()

@property (nonatomic, retain) NSArray *playButtons;
@property (nonatomic, retain) NSArray *pauseButtons;
@property (nonatomic, retain) NSArray *stopButtons;

@property (nonatomic, retain) NSArray *volumeSliders;
@property (nonatomic, retain) NSArray *scrubberSliders;
@property (nonatomic, retain) NSArray *bufferProgress;

@property (nonatomic, retain) NSArray *subAreas;
@property (nonatomic, retain) NSArray *playerViews;

@property (nonatomic, assign) BOOL isPreparedToPlay;

@property (nonatomic, retain) NSArray *subtitlesTexts;
@property (nonatomic, retain) NSArray *subtitlesTimes;

// AVFoundation Logics

@property (nonatomic, retain) id scrubbersTimeObserver;

@property (nonatomic, retain) AVPlayer        *player;
@property (nonatomic, retain) AVURLAsset      *urlAsset;
@property (nonatomic, retain) AVPlayerItem    *currentItem;

@property (nonatomic, retain) CAKeyframeAnimation *subtitlesAnimation;

- (void)helperLayerSubArea:(UILabel*)subArea;
- (void)playerItemDidReachEnd:(NSNotification *)notification;

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;

- (void)observeCurrentItemofObject:(AVPlayer*)object change:(NSDictionary *)change;
- (void)observeStatusofObject:(AVPlayerItem*)object change:(NSDictionary *)change;
- (void)observeRateofObject:(AVPlayerItem*)object change:(NSDictionary*)change;
- (void)observeLayerReadyForDisplayofObject:(AVPlayerLayer*)object change:(NSDictionary*)change;

- (void)initScrubberTimer;
- (void)syncScrubber;
- (void) syncBufferProgress:(CMTimeRange)newRange;

- (void)playButtonsEnabled:(BOOL)enabled;
- (void)pauseButtonsEnabled:(BOOL)enabled;
- (void)stopButtonsEnabled:(BOOL)enabled;
- (void)volumeSlidersEnabled:(BOOL)enabled;
- (void)scrubbersSlidersEnabled:(BOOL)enabled;
- (void)subAreasEnabled:(BOOL)enabled;
- (void)playerViewsEnabled:(BOOL)enabled;

@end

@implementation SnSSmartPlayerController

@synthesize playButtons = playButtons_;
@synthesize pauseButtons = pauseButtons_;
@synthesize stopButtons = stopButtons_;

@synthesize volumeSliders = volumeSliders_;
@synthesize scrubberSliders = scrubberSliders_;
@synthesize bufferProgress = bufferProgress_;

@synthesize subAreas = subAreas_;
@synthesize playerViews = playerViews_;

@synthesize delegate = delegate_;

@synthesize isPreparedToPlay = isPreparedToPlay_;
@synthesize enabled = enabled_;

@synthesize contentURL = contentURL_;

@synthesize subtitles = subtitles_;

@synthesize subtitlesTexts = subtitlesTexts_;
@synthesize subtitlesTimes = subtitlesTimes_;

@synthesize scrubbersTimeObserver = scrubbersTimeObserver_;

@synthesize player = player_;
@synthesize urlAsset = urlAsset_;
@synthesize currentItem = currentItem_;

@synthesize itemDuration = itemDuration_;

@synthesize subtitlesAnimation = subtitlesAnimation_;

# pragma mark CMTime Helpers

// CMTime Helper
CGFloat timeValueForCMTime(CMTime time)
{
    return CMTIME_IS_INVALID(time) ? 0.0f : CMTimeGetSeconds(time);
}

CGFloat keyframeTimeForTimeString(NSString* timeString, CMTime duration)
{
    CGFloat timeValue = timeString.floatValue;
    CGFloat durationValue = timeValueForCMTime(duration);
    
    return (1.0 / durationValue) * timeValue;
}

# pragma mark -
# pragma mark Getters / Setters
# pragma mark -

# pragma mark Getters

- (CMTime)itemDuration
{
    if (currentItem_ && currentItem_.status == AVPlayerItemStatusReadyToPlay)
    {
        /* 
         NOTE:
         Because of the dynamic nature of HTTP Live Streaming Media, the best practice 
         for obtaining the duration of an AVPlayerItem object has changed in iOS 4.3. 
         Prior to iOS 4.3, you would obtain the duration of a player item by fetching 
         the value of the duration property of its associated AVAsset object. However, 
         note that for HTTP Live Streaming Media the duration of a player item during 
         any particular playback session may differ from the duration of its asset. For 
         this reason a new key-value observable duration property has been defined on 
         AVPlayerItem.
         
         See the AV Foundation Release Notes for iOS 4.3 for more information.
         */		
        
        return(currentItem_.duration);
    }
    
    return(kCMTimeInvalid);
}

# pragma mark Setters

- (void)setScrubbersTimeObserver:(id)scrubbersTimeObserver
{
    if (scrubbersTimeObserver_ != scrubbersTimeObserver)
    {
        if (player_)
            [player_ removeTimeObserver:scrubbersTimeObserver_];
        
        [scrubbersTimeObserver_ release];
        scrubbersTimeObserver_ = [scrubbersTimeObserver retain];
    }
}

- (void)setPlayer:(AVPlayer *)player
{
    if (player_ != player)
    {
        if (player_)
        {
            [player_ removeObserver:self forKeyPath:kSPCurrentItemKey];
            [player_ removeObserver:self forKeyPath:kSPRateKey];
        }
        
		[player_ release];
        player_ = [player retain];

        if (!player_)
            return ;
        
        // Observe the AVPlayer "currentItem" property to find out when any 
        // AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did 
        // occur.
        [player_ addObserver:self 
                      forKeyPath:kSPCurrentItemKey 
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:SPCurrentItemObservationContext];
        
        // Observe the AVPlayer "rate" property to update the scrubber control.
        [player_ addObserver:self
                      forKeyPath:kSPRateKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:SPRateObservationContext];
        
        if (player_ && currentItem_)
            [playerViews_ makeObjectsPerformSelector:@selector(setPlayer:) withObject:player_];
        
    }
}

- (void)setCurrentItem:(AVPlayerItem *)currentItem
{
    if (currentItem_ != currentItem)
    {
        if (currentItem_)
        {
            [currentItem_ removeObserver:self forKeyPath:kSPStatusKey];
            [currentItem_ removeObserver:self forKeyPath:kSPLoadedTimeRangesKey];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:AVPlayerItemDidPlayToEndTimeNotification
                                                          object:currentItem_];
        }
        
        [currentItem_ release];
        currentItem_ = [currentItem retain];
         
        if (!currentItem_)
            return ;
        
//        // Observe the player item "status" key to determine when it is ready to play.
        [currentItem_ addObserver:self
                       forKeyPath:kSPStatusKey
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:SPStatusObservationContext];
        
        [currentItem_ addObserver:self
                         forKeyPath:kSPLoadedTimeRangesKey
                            options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                            context:SPBufferingObservationContext];

//        
        // When the player item has played to its end time we'll toggle
        // the movie controller Pause button to be the Play button.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:currentItem_];
        
        if (currentItem_)
            [subAreas_ makeObjectsPerformSelector:@selector(setPlayerItem:) withObject:currentItem_];
    }
}

- (void)setSubtitles:(NSArray *)subtitles
{
    if (subtitles_ != subtitles)
    {
        [subtitles_ release];
        subtitles_ = [subtitles retain];
        
        if (!subtitles || !subtitles_)
            return ;
        
        NSMutableArray *subtitleText = [[NSMutableArray alloc] init];
        NSMutableArray *subtitleFrame = [[NSMutableArray alloc] init];
        
        for (NSDictionary *subtitle in subtitles_)
        {
            if (![subtitle isKindOfClass:[NSDictionary class]])
                continue ;

            [subtitleText addObject:[subtitle objectForKey:@"text"]];
            [subtitleFrame addObject:[NSNumber numberWithFloat:
                                      keyframeTimeForTimeString([subtitle objectForKey:@"begin_time"], urlAsset_.duration)]];
            
            [subtitleText addObject:@""];
            [subtitleFrame addObject:[NSNumber numberWithFloat:
                                      keyframeTimeForTimeString([subtitle objectForKey:@"end_time"], urlAsset_.duration)]];
        }
        
        // First if need one - CAKeyFrameAnimation need a firstObject of 0.0f;
        if ([subtitleFrame count] && [(NSNumber*)[subtitleFrame objectAtIndex:0] floatValue] != 0.f)
        {
            [subtitleFrame insertObject:[NSNumber numberWithFloat:0.0f] atIndex:0];
            [subtitleText insertObject:@"" atIndex:0];
        }
        
        [subtitleFrame addObject:[NSNumber numberWithFloat:1.0f]];
        [subtitleText addObject:@""];
        
        subtitlesTexts_ = subtitleText;
        subtitlesTimes_ = subtitleFrame;
        
        self.subtitlesAnimation = [CAKeyframeAnimation animation];
        self.subtitlesAnimation.beginTime = AVCoreAnimationBeginTimeAtZero;
        self.subtitlesAnimation.calculationMode = kCAAnimationDiscrete;
        self.subtitlesAnimation.duration = CMTimeGetSeconds(urlAsset_.duration);
        self.subtitlesAnimation.keyPath = @"superlayer.delegate.text";

        self.subtitlesAnimation.values = subtitlesTexts_;
        self.subtitlesAnimation.keyTimes = subtitlesTimes_;
        
        for (UILabel* subA in subAreas_)
            [self helperLayerSubArea:subA];
    }
}

# pragma mark -
# pragma mark Initializers
# pragma mark -

+ (id)resourceNamed:(NSString *)name withExtension:(NSString *)extension
{
    NSURL *fileURL = [[NSBundle mainBundle]
                      URLForResource:name withExtension:extension];
    
    SnSSmartPlayerController *smartPlayer = [[SnSSmartPlayerController alloc] initWithContentURL:fileURL];
    
    return [smartPlayer autorelease];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
        ; // Init
    return self;
}

- (id)initWithContentURL:(NSURL *)url nibName:(NSString *)name
{
    if ((self = [super initWithNibName:name bundle:nil]) && url)
    {
        self.contentURL = url;
        self.urlAsset = [AVURLAsset URLAssetWithURL:contentURL_ options:nil];
        
        // player_ = [[AVPlayer alloc] init]; // Done on prepareToPlay when assetReady
        player_ = nil;
        currentItem_ = nil;
        delegate_ = nil;
        
        self.playButtons = [NSMutableArray array];
        self.pauseButtons = [NSMutableArray array];
        self.stopButtons = [NSMutableArray array];
        
        self.volumeSliders = [NSMutableArray array];
        self.scrubberSliders = [NSMutableArray array];
        self.bufferProgress = [NSMutableArray array];
        
        self.subAreas = [NSMutableArray array];
        self.playerViews = [NSMutableArray array];
        
        //        [self prepareToPlay];
        self.enabled = NO;
    }
    return self;
}


- (id)initWithContentURL:(NSURL *)url
{
    if ((self = [self initWithContentURL:url nibName:nil]) && url)
        return self;
    return nil;
}

# pragma mark -
# pragma mark G.U.I Initializers
# pragma mark -

# pragma mark Buttons

- (void)addPlayButton:(UIButton*)button
{
    if (![button isKindOfClass:[UIButton class]])
        return ;

    [playButtons_ addObject:button];
    
    [button addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addPauseButton:(UIButton*)button
{
    if (![button isKindOfClass:[UIButton class]])
        return ;
    
    [pauseButtons_ addObject:button];
    
    [button addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addStopButton:(UIButton*)button
{
    if (![button isKindOfClass:[UIButton class]])
        return ;
    
    [stopButtons_ addObject:button];
    
    [button addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
}

# pragma mark Sliders

- (void)addVolumeSlider:(UISlider*)slider
{
    if (![slider isKindOfClass:[UISlider class]])
        return ;
    
    [volumeSliders_ addObject:slider];

    [slider addTarget:self action:@selector(volumeChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)addScrubber:(UISlider*)slider
{
    if (![slider isKindOfClass:[UISlider class]])
        return ;
    
    [scrubberSliders_ addObject:slider];
    
    [slider addTarget:self action:@selector(beginScrubbing:) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpOutside];
}



- (void)addBufferProgress:(UIProgressView *)progress
{
    if (![progress isKindOfClass:[UIProgressView class]])
        return ;
    
    [bufferProgress_ addObject:progress];
    
}

# pragma mark Views

// Helper subArea
- (void)helperLayerSubArea:(UILabel*)subArea
{
    if (![subArea isKindOfClass:[UILabel class]] &&
        ![subArea isMemberOfClass:[SnSSmartSubtitleView class]])
        return ;
    
    ((AVSynchronizedLayer*)subArea.layer).playerItem = currentItem_;
    subArea.layer.sublayers = nil;
    
    CATextLayer *textLayer = [CATextLayer layer];
//    textLayer.delegate = subArea; // Crash on removeFromView
    textLayer.string = nil;
    textLayer.hidden = YES;
    textLayer.frame = (CGRect){0, 0, subArea.frame.size};

    [textLayer addAnimation:[[self.subtitlesAnimation copy] autorelease] forKey:@"superlayer.delegate.text"];
    
    CAKeyframeAnimation *monkeyFix = [[self.subtitlesAnimation copy] autorelease];
    monkeyFix.keyPath = @"string";
    
    [textLayer addAnimation:monkeyFix forKey:@"string"];
    
    [subArea.layer addSublayer:textLayer];
}

- (void)addSubArea:(UILabel*)subArea
{
    if (![subArea isKindOfClass:[UILabel class]] &&
        ![subArea isMemberOfClass:[SnSSmartSubtitleView class]])
        return ;
    
    [subAreas_ addObject:subArea];
    
    if (currentItem_)
    {
        [self helperLayerSubArea:subArea];
        ((SnSSmartSubtitleView*)subArea).playerItem = currentItem_;
    }
}

- (void)addPlayerView:(UIView*)playerView
{
    if (![playerView isKindOfClass:[UIView class]] &&
        ![playerView isMemberOfClass:[SnSSmartPlayerView class]])
        return ;
    
    [playerViews_ addObject:playerView];
    
    if (player_ && currentItem_)
        ((SnSSmartPlayerView*)playerView.layer).player = player_;
}



# pragma mark -
# pragma mark MPMediaPlayback Protocol Implementation 
# pragma mark -

- (void)play
{
    // If we are at the end of the movie, we must seek to the beginning first 
    // before starting playback.
	if (seekToZeroBeforePlay_) 
	{
		seekToZeroBeforePlay_ = NO;
		[self.player seekToTime:kCMTimeZero];
	}
    
    if ([self.playerViews count])
        ((UIView*)self.playerViews.lastObject).hidden = NO;
    
	[self.player play];
	
    // [self showStopButton]; // TODO Stop Button
}

- (void)pause
{
    [self.player pause];
}

- (void)stop
{
    [self.player pause];
    [self.player seekToTime:kCMTimeZero];
}

- (void)prepareToPlay
{
    self.enabled = YES;
    if (urlAsset_)
    {
        NSArray *requestedKeys = [NSArray arrayWithObjects:kSPTracksKey, kSPPlayableKey, nil];
        [urlAsset_ loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:^
         {
             for (NSString *key in requestedKeys)
             {
                 NSError *error = nil;
                 AVKeyValueStatus keyStatus = [urlAsset_ statusOfValueForKey:key error:&error];
                 if (keyStatus == AVKeyValueStatusFailed)
                     return ;    // TODO Handle error
             }
             
             // The asset is playable ?
//             if (!urlAsset_.playable)
//                 return; // TODO Handle Error
         
             // We are ready to setup/handle the playback
             // Create a AVPlayerItem, observing some value done in property setter
             self.currentItem = [AVPlayerItem playerItemWithAsset:urlAsset_];

             seekToZeroBeforePlay_ = NO;
             
             if (!player_)
                 self.player = [AVPlayer playerWithPlayerItem:currentItem_];
                 // Set player - observing some value done in property setter
             
//             SnSLogD(@"Is Player OK ?: %@ - Error: %@ && Status: %@", self.player, self.player.error, self.player.status);
             
             // Make our new AVPlayerItem the AVPlayer's current item.
             if (player_.currentItem != currentItem_)
             {
                 // Replace the player item with a new player item. The item replacement occurs 
                 // asynchronously; observe the currentItem property to find out when the 
                 // replacement will/did occur*/
                 [player_ replaceCurrentItemWithPlayerItem:currentItem_];

//                 [self syncPlayPauseButtons]; // TODO synButtons on Main Thread
             }
         }];
        
        [self syncScrubber];
        // TODO set scrubbers to zero
    }
}

- (void)beginSeekingBackward
{
    
}

- (void)beginSeekingForward
{
    
}


- (void)endSeeking;
{
    
}

# pragma mark -
# pragma mark Events
# pragma mark -

// The user is dragging the movie controller thumb to scrub through the movie.
- (IBAction)beginScrubbing:(id)sender
{
	restoreAfterScrubbingRate_ = player_.rate;
	player_.rate = 0.f;
	
	// Remove time observer while scrubbing
    self.scrubbersTimeObserver = nil;
}

// Set the player current time to match the scrubber position.
- (IBAction)scrub:(UISlider*)sender
{
	if (![sender isKindOfClass:[UISlider class]])
        return ;
    
    if (CMTIME_IS_INVALID(self.itemDuration))
        return;
    
    double duration = CMTimeGetSeconds(self.itemDuration);
    if (isfinite(duration))
    {
        float minValue = sender.minimumValue;
        float maxValue = sender.maximumValue;
        float value = sender.value;
        
        double time = duration * (value - minValue) / (maxValue - minValue);
        
        seekToZeroBeforePlay_ = NO;
        [player_ seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
    }
}

// The user has released the movie thumb control to stop scrubbing through the movie.
- (IBAction)endScrubbing:(id)sender
{
	if (!scrubbersTimeObserver_)
	{
		if (CMTIME_IS_INVALID(self.itemDuration)) 
			return;
		
		double duration = CMTimeGetSeconds(self.itemDuration);
		if (isfinite(duration))
		{
			CGFloat width = CGRectGetWidth(((UISlider*)scrubberSliders_.firstObject).bounds);
			double tolerance = 0.5f * duration / width;
            
			self.scrubbersTimeObserver = [player_ addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(tolerance, NSEC_PER_SEC) 
                                                                               queue:nil
                                                                          usingBlock:^(CMTime time)
                                          {
                                              [self syncScrubber];
//                                              dispatch_async(dispatch_get_main_queue(), ^{ [self syncScrubber]; });
                                          }];
		}
	}
    
	if (restoreAfterScrubbingRate_)
	{
		player_.rate = restoreAfterScrubbingRate_;
        restoreAfterScrubbingRate_ = 0.f;
	}
}

// TODO Be more generic
- (IBAction)volumeChanged:(UISlider *)sender
{
    AVMutableAudioMixInputParameters *params = nil;
    
    for (AVPlayerItemTrack *track in player_.currentItem.tracks)
    {
        if ([track.assetTrack.mediaType isEqual:AVMediaTypeAudio])
        {
            params = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track.assetTrack];
            break;
        }
    }
    
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    NSMutableArray *inputParameters = [NSMutableArray array]; 
    
    [params setVolume:sender.value atTime:kCMTimeZero];
    [inputParameters addObject:params];
    
    [audioMix setInputParameters:inputParameters];
    player_.currentItem.audioMix = audioMix;
}

# pragma mark -
# pragma mark Notifications
# pragma mark -

// Called when the player item has played to its end time.
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
	// After the movie has played to its end time, seek back to time zero 
    // to play it again.
	seekToZeroBeforePlay_ = YES;
    
    // We don't go back here, because the scrubber should not go back.

    if (delegate_ && [delegate_ respondsToSelector:@selector(smartPlayerDidReachEnd)])
        [delegate_ smartPlayerDidReachEnd];
    
    if ([self.playerViews count])
        ((UIView*)self.playerViews.lastObject).hidden = YES;
}

# pragma mark -
# pragma mark KVO - Observe implementation
# pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSString *stringSelector = nil;
    NSDictionary *reference = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"observeCurrentItemofObject:change:", [NSValue valueWithPointer:SPCurrentItemObservationContext],
                               @"observeStatusofObject:change:", [NSValue valueWithPointer:SPStatusObservationContext],
                               @"observeRateofObject:change:", [NSValue valueWithPointer:SPRateObservationContext],
                               @"observeLayerReadyForDisplayofObject:change:", [NSValue valueWithPointer:SPLayerReadyForDisplay],
                               @"observeBufferofObject:change:", [NSValue valueWithPointer:SPBufferingObservationContext],
                               nil];

    stringSelector = [reference objectForKey:[NSValue valueWithPointer:context]];
    if ((stringSelector = [reference objectForKey:[NSValue valueWithPointer:context]]) &&
        NSSelectorFromString(stringSelector) && 
        [self respondsToSelector:NSSelectorFromString(stringSelector)])
        [self performSelector:NSSelectorFromString(stringSelector) withObject:object withObject:change];

    if (stringSelector)
        return ;
    
    [super observeValueForKeyPath:keyPath ofObject:object
                           change:change context:context];
}

- (void)observeCurrentItemofObject:(AVPlayer*)object change:(NSDictionary *)change
{
    AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
    
    if (newPlayerItem == (id)[NSNull null])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playButtonsEnabled:NO];
            [self pauseButtonsEnabled:NO];
            [self stopButtonsEnabled:NO];
            
            [self scrubbersSlidersEnabled:NO];
        });
    }
    else // player currentItem replacement has occured
    {

        for (SnSSmartPlayerView* playerView in playerViews_)
        {
            if (![playerView isKindOfClass:[SnSSmartPlayerView class]])
                continue ;

            playerView.tag = 1;
            [playerView.layer addObserver:self
                               forKeyPath:@"readyForDisplay"
                                  options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                  context:SPLayerReadyForDisplay];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                playerView.layer.hidden = YES;
                [playerView setVideoFillMode:AVLayerVideoGravityResize];
            });
        }
        // TODO sync
    }
}

// Observe AVPlayerItem status = self.currentItem.status
- (void)observeStatusofObject:(AVPlayerItem*)object change:(NSDictionary *)change
{
//    AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
     AVPlayerStatus status = currentItem_.status;
    
    // TODO sync playPause button on MainThread
    
    if (status == AVPlayerStatusUnknown)
    {
        self.scrubbersTimeObserver = nil;
    }
    else if (status == AVPlayerStatusReadyToPlay)
    {
        [self initScrubberTimer]; // initScrubberTimer;
        [self initBufferProgress];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self syncScrubber];
      
        for (SnSSmartSubtitleView* sub in subAreas_)
            [self helperLayerSubArea:sub];
        
        bool enabled = (status == AVPlayerStatusReadyToPlay ? YES : NO);
        
        [self scrubbersSlidersEnabled:enabled];
        [self playButtonsEnabled:enabled];
        [self pauseButtonsEnabled:enabled];
        [self stopButtonsEnabled:enabled];
    });
    
    if (status == AVPlayerStatusFailed)
        self.enabled = NO;
    // TODO Handle ERROR AVPlayerStatusFailed
}

// Observe AVPlayerItem rate = self.currentItem.rate
- (void)observeRateofObject:(AVPlayerItem*)object change:(NSDictionary*)change
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if ([self.playerViews count])
//            ((UIView*)self.playerViews.lastObject).hidden = NO;
//    });
    // TODO Sync buttons
}

- (void)observeBufferofObject:(AVPlayerItem*)object change:(NSDictionary*)change
{
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        if ([self.playerViews count])
    //            ((UIView*)self.playerViews.lastObject).hidden = NO;
    //    });
    // TODO Sync buttons
    
    //NSLog(@"Buffering status: %@", [object loadedTimeRanges]);
    for (NSString * key in [change allKeys])
    {
        id value = [change objectForKey:key];
        //NSLog(@"change key = %@ ; value = %@",key, value);
        if ([value isKindOfClass:[NSArray class]] && [key isEqualToString:@"new"])
        {
            id keyValue = [[change objectForKey:key] objectAtIndex:0];
            CMTimeRange timeRangeValue = [((NSValue *)keyValue) CMTimeRangeValue];
            //NSLog(@"new key = %@ ; value = %@",key, keyValue);
            [self syncBufferProgress:timeRangeValue];
        }
    }

}

// Observe PlayerViews AVPlayerLayer readyForDisplay = playerView.layer.readyForDisplay
- (void)observeLayerReadyForDisplayofObject:(AVPlayerLayer*)object change:(NSDictionary*)change
{
    if ([[change objectForKey:NSKeyValueChangeNewKey] boolValue])
    {
        object.contentsGravity = kCAGravityResizeAspectFill;
        // object.hidden = NO;
        // [self.player play]; // Auto-Play
    }
}

# pragma mark -
# pragma mark Sync & G.U.I
# pragma mark -

// Requests invocation of a given block during media playback to update the movie scrubber control.
- (void)initScrubberTimer
{
    if (![scrubberSliders_ count])
        return ;
        
	double interval = .1f;	
	
	if (CMTIME_IS_INVALID(self.itemDuration))
		return;

	double duration = CMTimeGetSeconds(self.itemDuration);
	if (isfinite(duration))
	{
		CGFloat width = CGRectGetWidth(((UISlider*)scrubberSliders_.firstObject).bounds);
		interval = 0.5f * duration / width;
	}
    
	// Update the scrubber during normal playback.
    self.scrubbersTimeObserver = [player_ addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC) 
                                                                       queue:nil
                                                                  usingBlock:^(CMTime time) 
                                  { [self syncScrubber]; }];
}

// Set the scrubber based on the player current time.
- (void)syncScrubber
{
    if (![scrubberSliders_ count])
        return ;
    
	if (CMTIME_IS_INVALID(self.itemDuration)) 
	{
		((UISlider*)[scrubberSliders_ firstObject]).minimumValue = 0.0;
		return;
	}
    
	double duration = CMTimeGetSeconds(self.itemDuration);
	if (isfinite(duration))
	{
		float minValue = ((UISlider*)[scrubberSliders_ firstObject]).minimumValue;
		float maxValue = ((UISlider*)[scrubberSliders_ firstObject]).maximumValue;
		double time = CMTimeGetSeconds(player_.currentTime);
		
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.enabled)
            {
                ((UISlider*)[scrubberSliders_ firstObject]).value = (maxValue - minValue) * time / duration + minValue;
            }
            
            if (delegate_ !=nil && [delegate_ respondsToSelector:@selector(smartPlayerCurrentTime:)])
            {
                [delegate_ smartPlayerCurrentTime:time];
            }
            
        });
	}
}

// Requests invocation of a given block during media playback to update the movie scrubber control.
- (void)initBufferProgress
{
    if (![bufferProgress_ count])
        return ;
    
	double interval = .1f;
	
	if (CMTIME_IS_INVALID(self.itemDuration))
		return;
    
	double duration = CMTimeGetSeconds(self.itemDuration);
	if (isfinite(duration))
	{
		CGFloat width = CGRectGetWidth(((UIProgressView*)bufferProgress_.firstObject).bounds);
		interval = 0.5f * duration / width;
        ((UIProgressView*)bufferProgress_.firstObject).progress = 0.0;
	}
    
}

// Set the scrubber based on the player current time.
- (void)syncBufferProgress:(CMTimeRange)newRange
{
    if (![bufferProgress_ count])
        return ;
    
	if (CMTIMERANGE_IS_INVALID(newRange))
	{
		((UISlider*)[bufferProgress_ firstObject]).minimumValue = 0.0;
		return;
	}
    
	double totalDuration = CMTimeGetSeconds(self.itemDuration);
    double currentDurationLoaded = CMTimeGetSeconds(newRange.duration);
	if (isfinite(currentDurationLoaded) && isfinite(totalDuration))
	{
		dispatch_async(dispatch_get_main_queue(), ^{
            if (self.enabled && totalDuration > 0.0)
            {
                double pourcent = currentDurationLoaded / totalDuration;
                ((UIProgressView*)[bufferProgress_ firstObject]).progress = pourcent;
                
                if (delegate_ && [delegate_ respondsToSelector:@selector(smartPlayerBufferPourcent:)])
                {
                    [delegate_ smartPlayerBufferPourcent:pourcent];
                }
                
            }
        });
	}
}

- (void)playButtonsEnabled:(BOOL)enabled
{
    [playButtons_ makeObjectsPerformSelector:@selector(setEnabled:) withObject:(id)enabled];
}

- (void)pauseButtonsEnabled:(BOOL)enabled
{
    [pauseButtons_ makeObjectsPerformSelector:@selector(setEnabled:) withObject:(id)enabled];
}

- (void)stopButtonsEnabled:(BOOL)enabled
{
    [stopButtons_ makeObjectsPerformSelector:@selector(setEnabled:) withObject:(id)enabled];
}

- (void)volumeSlidersEnabled:(BOOL)enabled
{
    [volumeSliders_ makeObjectsPerformSelector:@selector(setEnabled:) withObject:(id)enabled];
}

- (void)scrubbersSlidersEnabled:(BOOL)enabled
{
    [scrubberSliders_ makeObjectsPerformSelector:@selector(setEnabled:) withObject:(id)enabled];
}

- (void)subAreasEnabled:(BOOL)enabled
{
    [subAreas_ makeObjectsPerformSelector:@selector(setEnabled:) withObject:(id)enabled];
}

- (void)playerViewsEnabled:(BOOL)enabled
{
    [playerViews_ makeObjectsPerformSelector:@selector(setEnabled:) withObject:(id)enabled];
}

# pragma mark -
# pragma mark Basics
# pragma mark -

- (void)viewWillDisappear:(BOOL)animated
{
    // MonkeyFix! with AVPlayer timeObservers
    self.scrubbersTimeObserver = nil;
}

- (void)shutdown
{
    [self stop];
    for (SnSSmartPlayerView* playerView in playerViews_)
    {
        if (playerView.tag)
        {
            [playerView.layer removeObserver:self forKeyPath:@"readyForDisplay"];
            playerView.tag = 0;
        }
    }
    
    ((SnSSmartPlayerView*)self.playerViews.lastObject).player = nil;
    self.player = nil;
    self.scrubbersTimeObserver = nil;
    self.enabled = NO;
}

- (void)dealloc
{	    
    SnSLogD(@"smartPlayer dealloc called.");
    
    for (UIButton *but in playButtons_)
        [but removeTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];

    for (UIButton *but in pauseButtons_)
        [but removeTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
                 
    for (UIButton *but in stopButtons_)
        [but removeTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];

    for (UISlider *vol in volumeSliders_)
        [vol removeTarget:self action:@selector(volumeChanged:) forControlEvents:UIControlEventValueChanged];
    
    for (UISlider *scrub in scrubberSliders_)
    {
        [scrub removeTarget:self action:@selector(beginScrubbing:) forControlEvents:UIControlEventTouchDown];
        [scrub removeTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
        [scrub removeTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpInside];
        [scrub removeTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpOutside];        
    }

    self.playButtons = nil;
    self.pauseButtons = nil;
    self.stopButtons = nil;
    
    self.volumeSliders = nil;
    self.scrubberSliders = nil;
    
    self.bufferProgress = nil;
    
    for (SnSSmartPlayerView* playerView in playerViews_)
    {
        if (playerView.tag)
        {
            [playerView.layer removeObserver:self forKeyPath:@"readyForDisplay"];
            playerView.tag = 0;
        }
    }

    ((SnSSmartPlayerView*)self.playerViews.lastObject).player = nil;
    
    self.subAreas = nil;
    self.playerViews = nil;
    
    self.delegate = nil;
    
    self.contentURL = nil;
    
    self.subtitles = nil;
    self.subtitlesTexts = nil;
    self.subtitlesTimes = nil;
    
    self.scrubbersTimeObserver = nil;
    
    self.player = nil;
    self.urlAsset = nil;
    self.currentItem = nil;
    
    self.subtitlesTimes = nil;
    
    [super dealloc];
}

@end
