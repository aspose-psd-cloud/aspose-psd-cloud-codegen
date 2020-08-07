#!/bin/bash
set -e
echo "Generating Java SDK"

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

cp -v templates/java/.swagger-codegen-ignore $sdkfolder/
rm -rfv $sdkfolder/src/main/java/com/aspose/psd/cloud/sdk/api
rm -rfv $sdkfolder/src/main/java/com/aspose/psd/cloud/sdk/model
if [ -f $sdkfolder/README.md ]
  then mv $sdkfolder/README.md $sdkfolder/README.md.bak
fi
rm -rf $sdkfolder/docs
java -jar tools/swagger-codegen-cli-2.4.5.jar generate -i $apiendpoint/v1.0/psd/swagger/sdkspec -l java --import-mappings JfifData=JfifData -DsupportJava6=true -DdateLibrary=legacy -t templates/java -o $sdkfolder -c config.java.json
mv $sdkfolder/README.md $sdkfolder/docs/API_README.md
mv $sdkfolder/README.md.bak $sdkfolder/README.md
mono tools/RequestModelExtractor.exe $sdkfolder/src/main/java/com/aspose/psd/cloud/sdk/api $sdkfolder/src/main/java/com/aspose/psd/cloud/sdk/model/requests/ java
rm -rf $sdkfolder/src/test/java/com/aspose/psd/cloud/sdk
rm -rf $sdkfolder/src/main/java/com/aspose/psd/cloud/sdk/invoker/auth
rm -rf $sdkfolder/gradle
