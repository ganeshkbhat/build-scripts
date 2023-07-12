#!/usr/bin/env bash

package=$1
if [[ -z "$package" ]]; then
  echo "usage: $0 <package-name>"
  echo "usage example: $0 example.com/caddy/caddy"
  exit 1
fi
package_split=(${package//\// })
package_name=${package_split[-1]}

rm -r -f ./dist

# platforms=("windows/amd64" "windows/386" "darwin/amd64" "darwin/amd64" "darwin/arm64" "js/wasm" "linux/386" "linux/amd64" "linux/arm" "linux/arm64")

platforms=("aix/ppc64" "android/amd64" "android/arm64" "darwin/amd64" "darwin/arm64" "dragonfly/amd64" "freebsd/386" "freebsd/amd64" "freebsd/arm" "freebsd/arm64" "freebsd/riscv64" "illumos/amd64" "js/wasm" "linux/386" "linux/amd64" "linux/arm" "linux/arm64" "linux/loong64" "linux/mips" "linux/mips64" "linux/mips64le" "linux/mipsle" "linux/ppc64" "linux/ppc64le" "linux/riscv64" "linux/s390x" "netbsd/386" "netbsd/amd64" "netbsd/arm" "netbsd/arm64" "openbsd/386" "openbsd/amd64" "openbsd/arm" "openbsd/arm64" "openbsd/mips64" "plan9/386" "plan9/amd64" "plan9/arm" "solaris/amd64" "windows/386" "windows/amd64" "windows/arm" "windows/arm64")
# "android/386" "ios/amd64" "ios/arm64" "android/arm" 

for platform in "${platforms[@]}"
do
	platform_split=(${platform//\// })
	GOOS=${platform_split[0]}
	GOARCH=${platform_split[1]}
	output_name=$package_name'-'$GOOS'-'$GOARCH
	if [ $GOOS = "windows" ]; then
		output_name+='.exe'
	fi	

	env GOOS=$GOOS GOARCH=$GOARCH go build -o ./dist/$output_name $package
	if [ $? -ne 0 ]; then
   		echo 'An error has occurred! Aborting the script execution...'
		exit 1
	fi
done
