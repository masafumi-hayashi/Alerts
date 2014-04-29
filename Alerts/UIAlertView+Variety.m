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
        [self ok];
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

- (instancetype)ok
{
    return [self ok:nil];
}

- (instancetype)ok:(void (^)())block
{
    return [self other:@"OK" block:block];
}

- (instancetype)cancel
{
    return [self cancel:nil];
}

- (instancetype)cancel:(void (^)())block
{
    return [self other:@"Cancel" block:block];
}

- (instancetype)other:(NSString *)title
{
    return [self other:title block:nil];
}

- (instancetype)other:(NSString *)title block:(void (^)())block
{
    [self addButtonWithTitle:NSLocalizedStringFromTable(title, @"Alerts", nil)];
    [[self blockDelegate].blocks setObject:[block copy] forKey:title];
    return self;
}
@end
