#import <Foundation/Foundation.h>

void NSPrintUTF8 (NSString *str)
{ 
	printf("%s", [str cStringUsingEncoding:NSUTF8StringEncoding]);
}

int main (int argc, const char * argv[]) {
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	NSPrintUTF8(@"Program: DRS to MP4 converter for SafeEYE B1 and alike car DVRs\n");
	NSPrintUTF8(@"Author : Konstantin Suvorov, 2012, www.berlic.net\n");
	
	NSString *filename = @"";	
	
	if (argc == 2) {
		filename = [filename stringByAppendingFormat:@"%s ",argv[1]];
		filename = [filename stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	
	if (argc == 1 || [filename isEqual:@""]) {
		NSPrintUTF8(@"Usage  : drs2mp4 full-file-name\n");
	}
	else {
		NSFileHandle *myHandle = [NSFileHandle fileHandleForUpdatingAtPath:filename];
		if (myHandle != nil) {
			const char mp4header[] = {
				0x00,0x00,0x00,0x18,0x66,0x74,0x79,0x70,
				0x6D,0x70,0x34,0x32,0x00,0x00,0x00,0x00,
				0x6D,0x70,0x34,0x32,0x69,0x73,0x6F,0x6D };
			NSData *myData = [NSData dataWithBytes:mp4header length:24];
			[myHandle writeData:myData];
			[myHandle closeFile];
			NSPrintUTF8(@"File modified successfully. Trying to rename to mp4...\n");
			NSString *newfilename = [filename stringByAppendingFormat:@".mp4"];
			[[NSFileManager defaultManager] moveItemAtPath:filename toPath:newfilename error:nil];
			NSPrintUTF8(@"File renamed successfully. You can open it with video player now.\n");
		}
		else {
			NSPrintUTF8(@"Error : Can't open file!\n");
		}
	}
  [pool drain];
  return 0;
}
