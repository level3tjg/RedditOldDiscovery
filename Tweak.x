#import <UIKit/UIKit.h>

@interface MainTabBarControllerImpl : UITabBarController
- (NSString *)discoverTabTitleWithIsDiscoverEnabled:(BOOL)isDiscoverEnabled
    shouldUseSearchLabelForDiscoverSearchIntegration:
        (BOOL)shouldUseSearchLabelForDiscoverSearchIntegration
                               isFeedControlsEnabled:(BOOL)isFeedControlsEnabled;
@end

static NSString *tabBarItemTitleOverride;

%hook _TtC13ExperimentKit17ExperimentManager
- (BOOL)isNewDiscoveryPageEnabledFor:(id)account {
  return NO;
}
%end

%hook _TtC34ExperimentKit_ExperimentManagement17ExperimentManager
- (BOOL)isNewDiscoveryPageEnabled {
  return NO;
}
%end

%hook MainTabBarControllerImpl
- (void)addCommunityTabBarItemToVC:(UIViewController *)VC {
  if ([self respondsToSelector:@selector
            (discoverTabTitleWithIsDiscoverEnabled:
                shouldUseSearchLabelForDiscoverSearchIntegration:isFeedControlsEnabled:)])
    tabBarItemTitleOverride = [self discoverTabTitleWithIsDiscoverEnabled:NO
                         shouldUseSearchLabelForDiscoverSearchIntegration:NO
                                                    isFeedControlsEnabled:YES];
  %orig;
  tabBarItemTitleOverride = nil;
}
%end

%hook UITabBarItem
- (instancetype)initWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage {
  return [self initWithTitle:nil image:image selectedImage:selectedImage];
}
- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                selectedImage:(UIImage *)selectedImage {
  if (tabBarItemTitleOverride) title = tabBarItemTitleOverride;
  return %orig;
}
%end
