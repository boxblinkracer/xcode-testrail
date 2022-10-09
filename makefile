.PHONY: help
.DEFAULT_GOAL := help


help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# ---------------------------------------------------------------------------------------------

devices: ## Lists all available Xcode devices
	xcrun xctrace list devices

# ---------------------------------------------------------------------------------------------

tests: ## Starts all Unit Tests
	cd src && xcodebuild test -scheme UnitTests -destination "platform=iOS Simulator,name=iPhone 14,OS=16.0"

lint: ## Runs the Pod Linter
	arch -x86_64 pod lib lint

# ---------------------------------------------------------------------------------------------

release: ## Releases a new version
	arch -x86_64 pod trunk push XcodeTestrail.podspec
