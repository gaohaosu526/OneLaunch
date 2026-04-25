#import "BridgingHeader.h"

NSArray<LSApplicationProxy *> *ObjcSafeGetApplications(void) {
    @try {
        LSApplicationWorkspace *ws = [LSApplicationWorkspace default];
        if (!ws) return nil;
        NSArray<LSApplicationProxy *> *apps = [ws allApplications];
        if (apps.count > 0) return apps;
        return [ws allInstalledApplications];
    } @catch (...) {
        return nil;
    }
}

BOOL ObjcSafeOpenApp(NSString *bundleID) {
    @try {
        LSApplicationWorkspace *ws = [LSApplicationWorkspace default];
        if (!ws) return NO;
        return [ws openApplicationWithBundleID:bundleID];
    } @catch (...) {
        return NO;
    }
}

UIImage *ObjcSafeGetIcon(LSApplicationProxy *proxy) {
    @try {
        return [proxy icon];
    } @catch (...) {
        return nil;
    }
}
