#import "AppDelegate.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MyHTTPConnection.h"
@interface AppDelegate ()
{
    HTTPServer *httpServer;
}
@end
//和DDlog 有关
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    httpServer = [[HTTPServer alloc] init];
    [httpServer setType:@"_http._tcp."];
    [httpServer setPort:3030];
    
    NSString *webPath = NSTemporaryDirectory();
    NSLog(@"Setting document root: %@", webPath);
    [httpServer setDocumentRoot:webPath];
        [httpServer setConnectionClass:[MyHTTPConnection class]];//引用myhttpconnection.m,提交post信息
    [self startServer];
    [self clearFileAtTmp];
    [self createIndexHelloWordFileAtTmp];
    return YES;
}
- (void)startServer
{
    // 开启服务器
    
    NSError *error;
    if([httpServer start:&error])
    {
        DDLogInfo(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
    }
    else
    {
        DDLogError(@"Error starting HTTP Server: %@", error);
    }
}
- (void)clearFileAtTmp{
    
    NSArray *fileAry  = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:NSTemporaryDirectory() error:nil];
    for (NSString *fileName in fileAry) {
        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    NSLog(@"clear over");
}
- (void)createIndexHelloWordFileAtTmp {
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"index.html"];
    NSString *hello = @"<!DOCTYPE html><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/><title></title></head>	<body><form action=\"upload.html\" method=\"post\" enctype=\"multipart/form-data\" accept-charset=\"utf-8\"><input type=\"file\" name=\"upload1\"/><br/><input type=\"file\" name=\"upload2\"/><br/><input type=\"submit\" value=\"Submit\"/></form></body></html>";
   // NSString *hello2=@"1231231231";
    FILE *fp = fopen([filePath UTF8String], "a+");
    if (fp ) {
        fwrite([[hello dataUsingEncoding:NSUTF8StringEncoding] bytes], [hello dataUsingEncoding:NSUTF8StringEncoding].length, 1, fp);
        fflush(fp);
//        fwrite([[hello2 dataUsingEncoding:NSUTF8StringEncoding] bytes],[hello2 dataUsingEncoding:NSUTF8StringEncoding].length,1 , fp);
//        fflush(fp);
    }
    fclose(fp);
    NSLog(@"file:%d",[[NSFileManager defaultManager]fileExistsAtPath:filePath]);
    NSString *filePath2 = [NSTemporaryDirectory() stringByAppendingPathComponent:@"upload.html"];
    hello=@"<!DOCTYPE html><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/><title></title></head><body><div>%MyFiles%</div></body></html>";
    fp=fopen([filePath2 UTF8String], "a+");
    if(fp)
    {
        fwrite([[hello dataUsingEncoding:NSUTF8StringEncoding] bytes], [hello dataUsingEncoding:NSUTF8StringEncoding].length, 1, fp);
        fflush(fp);
    }
    fclose(fp);
    
    NSLog(@"file:%d",[[NSFileManager defaultManager]fileExistsAtPath:filePath2]);
}
@end