#!/bin/bash

package=$1
if [[ -z "$package" ]]; then
  echo "usage: $0 <package-name>"
  exit 1
fi
package_split=(${package//\// })
package_name=${package_split[-1]}

echo "package_name: " ${package_name}

# Run the command and capture the output
oslist=$(go tool dist list)

echo "$oslist"

rm -r -f ./dist

for os in ${oslist[@]}

do	
  
  echo "Operating system / architecture: " ${os}
	readarray -d / -t output <<< "$os"
	
	echo ${output[0]}
	echo ${output[1]}

	output_name=$package_name'-'${output[0]}'-'${output[1]}

	echo ${output_name}
	output_name=`echo $output_name | awk '{$1=$1};1'`
  
  # alternative script to trim spaces
	# output_name=`echo $output_name | xargs`

	if [ ${output[0]} = "windows" ]; then
		env GOOS=${output[0]} GOARCH=${output[1]} go build -o ./dist/${output_name}.exe
	fi

	if [ ${output[0]} != "windows" ]; then
		env GOOS=${output[0]} GOARCH=${output[1]} go build -o ./dist/${output_name}
	fi

	# done
done
