//
//  ODR.m
//  Demo
//
//  Created by Joe.cheng on 2023/1/3.
//

#import "ODR.h"

typedef void(^ODRCompletion)(BOOL);
typedef void(^ODRError)(NSError *);

@interface ODR ()

@property (nonatomic, strong) NSBundleResourceRequest *resourceRequest;

@property (nonatomic, strong) NSMutableArray <NSBundleResourceRequest *> *lowPriorityRequests;

@property (nonatomic, copy) void (^completionHandler)(BOOL);

@property (nonatomic, copy) void (^errorBlock)(NSError *);

@end

@implementation ODR


- (instancetype)initWithTags:(NSSet<NSString *> *)tags
                  completion:(void (^)(BOOL resourcesAvailable))completionHandler
                       error:(void (^)(NSError *error))errorBlock{
    if (self = [super initWithTags:tags]) {
        self.completionHandler = completionHandler;
        self.errorBlock = errorBlock;
        
        [self setup];
        [self addObserver];
    }
    return self;
}

- (void)setup{
    
    // The priority is a number between 0.0 and 1.0
    self.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent;
    // Request access to tags that may already be on the device
    [self conditionallyBeginAccessingResourcesWithCompletionHandler:
         ^(BOOL resourcesAvailable)
     {
        // Check whether the resources are available
        if (resourcesAvailable) {
            // the associated resources are loaded, start using them
            //                self.loadNewWorldArea = YES;
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                self.completionHandler(YES);
            }];
        } else {
            // The resources are not on the device and need to be loaded
            // Queue up a call to a custom method for loading the tags using
            // beginAccessingResourcesWithCompletionHandler:
            
            [self beginAccessingResourcesWithCompletionHandler:^(NSError * _Nullable error) {
                // Check if there is an error
                if (error) {
                    // There is a problem so update the app state
                    //                    self.resourcesLoaded = NO;
                    
                    // Should also inform the user of the error
                    self.errorBlock(error);
                    return;
                }
                
                // The associated resources are loaded
                //                self.resourcesAvailable = YES;
                
                [NSOperationQueue.mainQueue addOperationWithBlock:^{
                    self.completionHandler(YES);
                }];
            }];
            
            
        }
    }
    ];
}


- (void)addObserver{
    
    // Start observing fractionCompleted to track the progress
    [self.resourceRequest.progress addObserver:self
                                   forKeyPath:@"fractionCompleted"
                                   options:NSKeyValueObservingOptionNew
                                   context:@"observeForrestLoad"
    ];
     
    // Stop observing fractionCompleted to stop tracking the progress
    [self.resourceRequest.progress removeObserver:self
                                   forKeyPath:@"fractionCompleted"
                                   context:@"observeForrestLoad"
    ];
    
    // Register to call self.lowDiskSpace when the notification occurs
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(lowDiskSpace:)
               name:NSBundleResourceRequestLowDiskSpaceNotification
             object:nil
    ];
}


-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    // Check for the progress object and key
    if ((object == self.resourceRequest.progress) &&
        ([keyPath isEqualToString:@"fractionCompleted"])) {
        // Get the current progress as a value between 0 and 1
        double progressSoFar = self.resourceRequest.progress.fractionCompleted;
 
        // Do something with the value
        NSLog(@"%f",progressSoFar);
    }
}

// Notification handler for low disk space warning
-(void)lowDiskSpace:(NSNotification*)theNotification
{
    // Free the lower priority resource requests
    for (NSBundleResourceRequest *atRequest in self.lowPriorityRequests) {
        // End accessing the resources
        [atRequest endAccessingResources];
    }
 
    // clear lowPriorityRequests preventing multiple calls to endAccesingResource
    [self.lowPriorityRequests removeAllObjects];
}

- (NSMutableArray<NSBundleResourceRequest *> *)lowPriorityRequests{
    if (!_lowPriorityRequests) {
        _lowPriorityRequests = [NSMutableArray array];
    }
    return _lowPriorityRequests;
}

@end
