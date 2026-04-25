#ifndef BridgingHeader_h
#define BridgingHeader_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// LSApplicationProxy: represents an installed app
@interface LSApplicationProxy : NSObject
@property (nonatomic, readonly) NSString *applicationIdentifier;
@property (nonatomic, readonly) NSString *localizedName;
@property (nonatomic, readonly) NSDictionary *iconsDictionary;
@property (nonatomic, readonly) NSArray<NSString *> *claimedURLSchemes;
@property (nonatomic, readonly) NSURL *bundleURL;
@property (nonatomic, readonly) NSString *shortVersionString;
- (UIImage *)icon;
@end

// LSApplicationWorkspace: enumerates all installed apps
@interface LSApplicationWorkspace : NSObject
+ (instancetype)defaultWorkspace;
- (NSArray<LSApplicationProxy *> *)allApplications;
- (BOOL)openApplicationWithBundleID:(NSString *)bundleID;
@end

#endif
