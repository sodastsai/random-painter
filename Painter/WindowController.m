//
//  WindowController.m
//  Painter
//
//  Created by sodas on 10/31/16.
//  Copyright © 2016 sodastsai. All rights reserved.
//

#import "WindowController.h"

#define let __auto_type const
#define guard(CONDITION) if (CONDITION) {}

NSNotificationName const WindowControllerRectanglesCountDidChange = @"WindowControllerRectanglesCountDidChange";

@interface WindowController ()

@property (nonatomic, readwrite) NSInteger rectanglesMinCount;
@property (nonatomic, readwrite) NSInteger rectanglesMaxCount;

@end

static void *WindowControllerKVOContext = &WindowControllerKVOContext;

@implementation WindowController

- (void)awakeFromNib {
    [super awakeFromNib];

    self.rectanglesMaxCount = 20;
    self.rectanglesMinCount = 1;
    self.rectanglesCount = 5;

    [self addObserver:self
           forKeyPath:@"rectanglesCount"
              options:NSKeyValueObservingOptionNew
              context:WindowControllerKVOContext];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"rectanglesCount" context:WindowControllerKVOContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (context == WindowControllerKVOContext) {
        if (object == self && [keyPath isEqualToString:@"rectanglesCount"]) {
            id newRectanglesCount = change[NSKeyValueChangeNewKey];
            let notification = [NSNotification notificationWithName:WindowControllerRectanglesCountDidChange
                                                             object:self
                                                           userInfo:@{@"value": newRectanglesCount}];
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                       postingStyle:NSPostASAP
                                                       coalesceMask:NSNotificationCoalescingOnName
                                                           forModes:@[NSDefaultRunLoopMode]];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.titleVisibility = NSWindowTitleHidden;
}

@end
