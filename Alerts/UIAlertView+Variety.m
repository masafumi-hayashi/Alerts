//
//  UIAlertView+Variety.m
//  Alerts
//
//  Created by masafumi hayashi on 4/29/14.
//  Copyright (c) 2014 masafumi hayashi. All rights reserved.
//

#import "UIAlertView+Variety.h"

@import ObjectiveC;

static char * const delegate_key = "alert_delegate";

typedef void(^Block)();

@interface SimpleAlertView : UIAlertView

@end

@implementation SimpleAlertView

- (void)show
{
    if (self.numberOfButtons == 0) {
        [self addOkButton];
    }
    [super show];
}

@end

@interface BlockDelegate : NSObject <UIAlertViewDelegate>
@property (nonatomic) NSMapTable * blocks;
@end

@implementation BlockDelegate

- (id)init
{
    self = [super init];
    if (self) {
        _blocks = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * title = [alertView buttonTitleAtIndex:buttonIndex];
    Block block = [_blocks objectForKey:title];
    if (block) {
        block();
    }
}

@end


static UIAlertView * make_alert(NSString * title, NSString * message)
{
    return [[SimpleAlertView alloc] initWithTitle:NSLocalizedStringFromTable(title, @"Alerts", nil)
                                          message:NSLocalizedStringFromTable(message, @"Alerts", nil)
                                         delegate:nil
                                cancelButtonTitle:nil
                                otherButtonTitles:nil];
}

@implementation UIAlertView (Variety)
+ (instancetype)alertWithMessage:(NSString *)message
{
    return make_alert(nil, message);
}

+ (instancetype)alertWithConfirmMessage:(NSString *)message
{
    return make_alert(@"Confirm", message);
}

+ (instancetype)alertWithErrorMessage:(NSString *)message
{
    return make_alert(@"Error", message);
}

+ (instancetype)alertWithDebugMessage:(NSString *)message
{
    return make_alert(@"Debug", message);
}

+ (instancetype)alertWithInfoMessage:(NSString *)message
{
    return make_alert(@"Info", message);
}

+ (instancetype)alertWithWarningMessage:(NSString *)message
{
    return make_alert(@"Warning", message);
}

- (instancetype)title:(NSString *)title
{
    [self setTitle:title];
    return self;
}

- (BlockDelegate *)blockDelegate
{
    BlockDelegate * delegate = objc_getAssociatedObject(self, delegate_key);
    if (!delegate) {
        delegate = [BlockDelegate new];
        self.delegate = delegate;
        objc_setAssociatedObject(self,
                                 delegate_key,
                                 delegate,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (instancetype)addOkButton
{
    return [self addOkButton:nil];
}

- (instancetype)addOkButton:(void (^)())block
{
    return [self addButton:@"OK" block:block];
}

- (instancetype)addCancelButton
{
    return [self addCancelButton:nil];
}

- (instancetype)addCancelButton:(void (^)())block
{
    return [self addButton:@"Cancel" block:block];
}

- (instancetype)addButton:(NSString *)title
{
    return [self addButton:title block:nil];
}

- (instancetype)addButton:(NSString *)title block:(void (^)())block
{
    if (![self hasButton:title]) {
        NSUInteger idx = [self addButtonWithTitle:NSLocalizedStringFromTable(title, @"Alerts", nil)];
        if ([title isEqualToString:@"Cancel"]) {
            self.cancelButtonIndex = idx;
        }
    }
    [[self blockDelegate].blocks setObject:[block copy] forKey:title];
    return self;
}

- (BOOL)hasButton:(NSString *)title
{
    NSUInteger len = self.numberOfButtons;
    for (NSUInteger i = 0; i < len; i++) {
        if ([[self buttonTitleAtIndex:i] isEqualToString:title]) {
            return YES;
        }
    }
    return NO;
}

@end
