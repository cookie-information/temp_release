
xcodebuild archive -scheme MobileConsentsSDK -archivePath "../sdkArchives/simulator.archive" -destination "generic/platform=iOS Simulator"  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive -scheme MobileConsentsSDK -archivePath "../sdkArchives/ios.archive" -destination "generic/platform=iOS" SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild -create-xcframework \
-framework ../sdkArchives/simulator.archive.xcarchive/Products/Library/Frameworks/MobileConsentsSDK.framework  \
-framework ../sdkArchives/ios.archive.xcarchive/Products/Library/Frameworks/MobileConsentsSDK.framework \
-output ../sdkArchives/MobileConsentsSDK.xcframework

