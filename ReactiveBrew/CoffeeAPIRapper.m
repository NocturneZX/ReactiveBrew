//
//  CoffeeAPIRapper.m
//  ReactiveBrew
//
//  Created by Julio Reyes on 8/31/15.
//  Copyright (c) 2015 Julio Reyes. All rights reserved.
//

#import "Coffee.h"
#import "CoffeeAPIRapper.h"
#import "APICredentials.h"

static NSString * const CoffeeBaseURL = @"https://coffeeapi.percolate.com/api/coffee/";
NSString *const JR3ErrorDomain = @"JR3ErrorDomain";
NSInteger const JR3ErrorCode = -42;

@interface CoffeeAPIRapper ()
@property(nonatomic, copy, readwrite) NSURL *baseURL;
@property (nonatomic, copy) NSURLSession *brewSession;
@end

@implementation CoffeeAPIRapper

+(CoffeeAPIRapper *)sharedCoffee{
    static CoffeeAPIRapper *sharedCoffeeAPIClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCoffeeAPIClient = [[self alloc] initWithCoffeeURL:[NSURL URLWithString:CoffeeBaseURL]];
        sharedCoffeeAPIClient.brewSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]delegate:sharedCoffeeAPIClient delegateQueue:nil];
        sharedCoffeeAPIClient.brewSession.sessionDescription = @"It's time to get sum coffee!";
        
    });
    return sharedCoffeeAPIClient;
}

- (id)init
{
    NSException *exception = [NSException exceptionWithName:@"Singleton" reason:@"Use +(CoffeeAPIRapper *)sharedCoffee instead" userInfo:nil];
    [exception raise];
    return nil;
}

-(instancetype)initWithCoffeeURL:(NSURL *)url{
    if (self = [super init]) {
        self.baseURL = url;
    }
    return self;
}

-(RACSignal *)fetchmeSomeCoffee{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSMutableURLRequest *brewRequest = [NSMutableURLRequest requestWithURL:self.baseURL];
            brewRequest.HTTPMethod = @"GET";
            
            [brewRequest setValue:API_KEY forHTTPHeaderField:@"Authorization"];
            
            [brewRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [brewRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

            NSURLSessionDataTask *downloadBrew = [self.brewSession dataTaskWithRequest:brewRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
                
                if(connectionError)
                {
                    [subscriber sendError:connectionError];
                }
                else if(!data)
                {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No data was received from the server."};
                    NSError *dataError = [NSError errorWithDomain:JR3ErrorDomain code:JR3ErrorCode userInfo:userInfo];
                    [subscriber sendError:dataError];
                }
                else{
                    NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];

                    NSMutableArray *filteredArray = [NSMutableArray array];
                    for (NSDictionary *brew in results) {
                        id obj = [brew objectForKey:@"id"];
                        if ([obj isKindOfClass:[NSString class]]) {
                            [filteredArray addObject:brew];
                        }
                    }
                    
                    NSError *didFail;
                    NSArray *brewBatches = [MTLJSONAdapter modelsOfClass:[Coffee class] fromJSONArray:filteredArray error:&didFail];

                    [subscriber sendNext:brewBatches];
                    [subscriber sendCompleted];
                }
            }];
            
            [downloadBrew resume];
            
            return [RACDisposable disposableWithBlock:^{
                [downloadBrew cancel];
            }];
            
        }];
}
-(RACSignal *)fetchmeMoreCoffeeInfo:(NSString *)coffeeID{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSURL *coffeeURL = [NSURL URLWithString:coffeeID relativeToURL:self.baseURL];
        
        NSMutableURLRequest *brewRequest = [NSMutableURLRequest requestWithURL:coffeeURL];
        brewRequest.HTTPMethod = @"GET";
        
        [brewRequest setValue:API_KEY forHTTPHeaderField:@"Authorization"];
        
        [brewRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [brewRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSURLSessionDataTask *downloadBrew = [self.brewSession dataTaskWithRequest:brewRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
            
            if(connectionError)
            {
                [subscriber sendError:connectionError];
            }
            else if(!data)
            {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No data was received from the server."};
                NSError *dataError = [NSError errorWithDomain:JR3ErrorDomain code:JR3ErrorCode userInfo:userInfo];
                [subscriber sendError:dataError];
            }
            else{
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
                
                [subscriber sendNext:results];
                [subscriber sendCompleted];
            }
        }];
        
        [downloadBrew resume];
        
        return [RACDisposable disposableWithBlock:^{
            [downloadBrew cancel];
        }];
    }];
}
-(RACSignal *)resetData{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        return nil;
    }];
}

@end
