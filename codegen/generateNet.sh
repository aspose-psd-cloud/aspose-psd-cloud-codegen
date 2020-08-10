#!/bin/bash
set -e
echo "Generating .Net SDK"

sdkfolder=$1
if [ "$1" != "" ]; then
  echo "Output directory: " $sdkfolder
else
  echo "Please, specify ouput directory"
  exit 1
fi

apiendpoint=$2
if [ "$2" == "" ]; then
  apiendpoint=https://api-qa.aspose.cloud/
fi
echo "API endpoint: " $apiendpoint

cp -v templates/csharp/.swagger-codegen-ignore $sdkfolder/
rm -rfv $sdkfolder/src/Aspose.Imaging.Cloud.Sdk/Api
rm -rfv $sdkfolder/src/Aspose.Imaging.Cloud.Sdk/Model
if [ -f $sdkfolder/README.md ]
  then mv $sdkfolder/README.md $sdkfolder/README.md.bak
fi
rm -rfv $sdkfolder/docs
java -jar tools/swagger-codegen-cli-2.4.5.jar generate -i $apiendpoint/v3.0/psd/swagger/sdkspec -l csharp -t templates/csharp -o $sdkfolder -c config.net.json
mv $sdkfolder/README.md $sdkfolder/docs/API_README.md
mv $sdkfolder/README.md.bak $sdkfolder/README.md
mono tools/RequestModelExtractor.exe $sdkfolder/src/Aspose.Psd.Cloud.Sdk/Api/ $sdkfolder/src/Aspose.Psd.Cloud.Sdk/Model/Requests/ csharp
