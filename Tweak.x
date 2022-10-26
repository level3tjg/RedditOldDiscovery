#import <Foundation/Foundation.h>

%hook _TtC13ExperimentKit17ExperimentManager
- (BOOL)isNewDiscoveryPageEnabledFor:(id)account {
  return NO;
}
%end
