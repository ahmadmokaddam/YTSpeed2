// -----------------|
// By Ahmad Mokadam |
// Compatible with the latest version of YouTube 19.09.3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <substrate.h>
#import <spawn.h>

// Get YouTubeHeader From  https://github.com/PoomSmart/YouTubeHeader/
#import "../YouTubeHeader/_ASDisplayView.h"
#import "../YouTubeHeader/YTActionSheetDialogViewController.h"
#import "../YouTubeHeader/YTResponder.h"
#import "../YouTubeHeader/YTVideoQualitySwitchOriginalController.h"
#import "../YouTubeHeader/YTVideoQualitySwitchRedesignedController.h"

// original Tweak https://github.com/therealFoxster/YTSpeed/blob/3ddaf3d0e1b49b69a428d1ac877cf3bde8dd0861/Tweak.xm

// https://github.com/Lyvendia/YTSpeed/blob/main/Tweak.xm


// I had the same idea (// YTClassicVideoQuality - https://github.com/PoomSmart/YTClassicVideoQuality)
// Then I programmed the method and applied it to (YTSpeed)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#pragma clang diagnostic pop
#define DEFAULT_RATE 2.0f

@interface YTVarispeedSwitchControllerOption : NSObject
- (id)initWithTitle:(id)title rate:(float)rate;
@end

@interface YTPlayerViewController : NSObject ////////
@property id activeVideo;
@property float playbackRate;
- (void)singleVideo:(id)video playbackRateDidChange:(float)rate;
@end

@interface MLHAMQueuePlayer : NSObject ///////
@property id playerEventCenter;
@property id delegate;
- (void)setRate:(float)rate;
- (void)internalSetRate;
@end

@interface MLPlayerStickySettings : NSObject
- (void)setRate:(float)rate;
@end

@interface MLPlayerEventCenter : NSObject
- (void)broadcastRateChange:(float)rate;
@end

@interface YTSingleVideoController : NSObject
- (void)playerRateDidChange:(float)rate;
@end

@interface HAMPlayerInternal : NSObject
- (void)setRate:(float)rate;
@end



static BOOL isVarispeedSelectionNode(ASDisplayNode *node) {
    NSString *identifier = node.accessibilityIdentifier;
    // bortogal
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_Velocidade da reprodução"]) {
        return YES;
    }

    // English
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_Playback speed"]) {
        return YES;
    }

    // Arabic
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_سرعة التشغيل"]) {
        return YES;
    }

    // German
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_Wiedergabegeschwindigkeit"]) {
        return YES;
    }

    // Italian
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_velocità di riproduzione"]) {
        return YES;
    }

    // Dutch
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_afspeelsnelheid"]) {
        return YES;
    }

    // Romanian
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_viteză de redare"]) {
        return YES;
    }

    // Greek
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_ταχύτητα αναπαραγωγής"]) {
        return YES;
    }

    // Turkish
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_yeniden çalma hızı"]) {
        return YES;
    }

    // Polish
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_szybkość odtwarzania"]) {
        return YES;
    }

    // Czech
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_rychlost přehrávání"]) {
        return YES;
    }

    // Serbian
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_brzina reprodukcije"]) {
        return YES;
    }

    // Persian
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_سرعت پخش"]) {
        return YES;
    }

    // Hebrew
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_מהירות השמעה"]) {
        return YES;
    }

    // Filipino
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_bilis ng pag-playback"]) {
        return YES;
    }

    // Vietnamese
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_tốc độ phát lại"]) {
        return YES;
    }

    // Thai
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_ความเร็วการเล่น"]) {
        return YES;
    }

    // Urdu
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_پلے بیک کی رفتار"]) {
        return YES;
    }

    // African (Fula)
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_ibi oni"]) {
        return YES;
    }

    // Hausa
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_kuri m"]) {
        return YES;
    }

    // Yoruba
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_irò"]) {
        return YES;
    }

    // Igbo
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_ọrụ"]) {
        return YES;
    }

    // Swahili
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_kasi"]) {
        return YES;
    }

    // Zulu
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_yokuqhuba"]) {
        return YES;
    }

    // French
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_vitesse de lecture"]) {
        return YES;
    }

    // Spanish
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_velocidad de reproducción"]) {
        return YES;
    }

    // Chinese
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_播放速度"]) {
        return YES;
    }

    // Japanese
    if ([identifier hasPrefix:@"id.elements.components.overflow_menu_item_再生速度"]) {
        return YES;
    }

    // Add more languages as needed...

    return NO;
}


%hook YTVarispeedSwitchControllerOption

- (id)initWithTitle:(id)arg1 rate:(float)arg2 {
    id result = %orig;
    return result;
}
%end

static id createVarispeedOption(NSString *title, float rate) {
    Class optionClass = objc_getClass("YTVarispeedSwitchControllerOption");

    if (optionClass) {
        SEL initWithTitleRateSelector = NSSelectorFromString(@"initWithTitle:rate:");
        id option = [optionClass alloc];

        if ([option respondsToSelector:initWithTitleRateSelector]) {
            option = [option initWithTitle:title rate:rate];
        }

        return option;
    }

    return nil;
}

%hook YTVarispeedSwitchController
- (id)init {
    id result = %orig;

    float speeds[] = {0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75, 3.0, 3.25, 3.5, 3.75, 4.0, 5.0};
    int size = sizeof(speeds) / sizeof(speeds[0]);

    NSMutableArray *varispeedSwitchControllerOptions = [NSMutableArray array];

    for (int i = 0; i < size; ++i) {
        float rate = speeds[i];
        NSString *title = [NSString stringWithFormat:@"%.2fx", rate];

        id option = createVarispeedOption(title, rate);

        if (option) {
            [varispeedSwitchControllerOptions addObject:option];
        }
    }

    MSHookIvar<NSArray *>(self, "_options") = varispeedSwitchControllerOptions;

    return result;
}
%end

%hook _ASDisplayView
- (void)didMoveToWindow {
    %orig;

    ASDisplayNode *node = self.keepalive_node;
    if (![node respondsToSelector:@selector(accessibilityIdentifier)]) return;
    if (!isVarispeedSelectionNode(node)) return;

    YTActionSheetDialogViewController *vc = (YTActionSheetDialogViewController *)[node closestViewController];
    if (![vc isKindOfClass:objc_getClass("YTActionSheetDialogViewController")]) return;
    if (![vc.parentViewController isKindOfClass:objc_getClass("YTBottomSheetController")]) return;
    id <YTResponder> sc = (id <YTResponder>)vc.delegate;
    id c = [sc parentResponder];
    if (![c isKindOfClass:objc_getClass("YTMainAppVideoPlayerOverlayViewController")]) return;

    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:gesture];
            break;
        }
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:c action:@selector(didPressVarispeed:)];
    [self addGestureRecognizer:tap];
}
%end
