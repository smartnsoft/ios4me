default:
	# Set default make action here 
	xcodebuild -target "${PROJECT} (Device)" -configuration ${CONFIGURATION} -project "${PROJECT}.xcodeproj"
	xcodebuild -target "${PROJECT} (Simulator)" -configuration ${CONFIGURATION} -project "${PROJECT}.xcodeproj"
	sh ${PROJECT}/iOSFramework.sh

# If you need to clean a specific target/configuration: $(COMMAND) -target $(TARGET) -configuration DebugOrRelease -sdk $(SDK) clean
clean:
	-rm -rf build/*

test:
	#change the target to whatever needs to be tested
	GHUNIT_CLI=1 xcodebuild -target Tests -configuration ${BUILD_STYLE} build
