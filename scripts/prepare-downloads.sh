#!/usr/bin/env bash

set -e

declare -r tutorial_sources="${PWD}/docs-source/docs/modules/microservices-tutorial/examples"
declare -r tutorial_attachments="${PWD}/docs-source/docs/modules/microservices-tutorial/assets/attachments"
declare -r tutorial_temporal_attachments="${PWD}/target/microservices-tutorial/_attachments"

declare -r howto_sources="${PWD}/docs-source/docs/modules/how-to/examples"
declare -r howto_attachments="${PWD}/docs-source/docs/modules/how-to/assets/attachments"
declare -r howto_temporal_attachments="${PWD}/target/how-to/_attachments"

declare -r temporal_folder="${PWD}/target/zips"
mkdir -p ${howto_temporal_attachments}
mkdir -p ${tutorial_temporal_attachments}

mkdir -p ${tutorial_attachments}
mkdir -p ${howto_attachments}

function sed_command() {
   local platform="$(uname -s | tr '[:upper:]' '[:lower:]')"

   if [ "${platform}" != "darwin" ]; then
      echo "sed"
   else
      # using gnu-sed on Mac
      echo "gsed"
   fi
}

## Remove the tags used by Antora snippets from 
## the codebase in the current folder
function removeTags() {
   ## remove tags from code
   find . -type f -print0 | xargs -0 $(sed_command) -i "s/\/\/ tag::[^\[]*\[.*\]//g"
   find . -type f -print0 | xargs -0 $(sed_command) -i "s/\/\/ end::[^\[]*\[.*\]//g"
   
   ## remove tags from config
   find . -type f -print0 | xargs -0 $(sed_command) -i "s/# tag::[^\[]*\[.*\]//g"
   find . -type f -print0 | xargs -0 $(sed_command) -i "s/# end::[^\[]*\[.*\]//g"

   ## remove call-outs ("// <3>" and "# <4>")
   find . -type f -print0 | xargs -0 $(sed_command) -i "s/\/\/ <[0-9]*>//g" 
   find . -type f -print0 | xargs -0 $(sed_command) -i "s/#[ ]*<[0-9]*>//g" 
}


## Cleanup the temporal folder from previous executions
function prepareTemporalFolder() {
   rm -rf ${temporal_folder}
   mkdir -p ${temporal_folder}
}

## Copy a folder with some code into the temporal folder. The 
## copied folder will be renamed to the folder name we want the 
## user to see when unzipping the file.
##   source_name -> folder in `examples`
##   target_name ->  folder name the user should see (must not use a numeric prefix of a laguage suffix)
function fetchProject() {
   source_name=$1
   target_name=$2
   echo "Fetching content from [$1] to [$2]"
   cp -a ${source_name} ${temporal_folder}/${target_name}
}

## Zip the contents in $temporal_folder and create the 
## attachment file (aka, the ZIP file on the appropriate location)
function zipAndAttach() {
   zip_name=$1
   temporal_attachments=$2
   echo "Preparing ZIP $1"
   pushd ${temporal_folder}
   removeTags
   zip --quiet -r ${zip_name} *
   cp ${zip_name} ${temporal_attachments}
   echo "Prepared attachment at ${zip_name}"
   popd
}


## Scala Zip files
## empty seed template
prepareTemporalFolder
fetchProject ${tutorial_sources}/00-shopping-cart-service-scala shopping-cart-service
fetchProject ${tutorial_sources}/00-shopping-analytics-service-scala shopping-analytics-service
fetchProject ${tutorial_sources}/00-shopping-order-service-scala shopping-order-service
zipAndAttach ${tutorial_attachments}/0-shopping-cart-start-scala.zip ${tutorial_temporal_attachments}

## gRPC service
prepareTemporalFolder
fetchProject ${tutorial_sources}/01-shopping-cart-service-scala shopping-cart-service
fetchProject ${tutorial_sources}/00-shopping-analytics-service-scala shopping-analytics-service
fetchProject ${tutorial_sources}/00-shopping-order-service-scala shopping-order-service
zipAndAttach ${tutorial_attachments}/1-shopping-cart-grpc-scala.zip ${tutorial_temporal_attachments}

## basic entity
prepareTemporalFolder
fetchProject ${tutorial_sources}/02-shopping-cart-service-scala shopping-cart-service
fetchProject ${tutorial_sources}/00-shopping-analytics-service-scala shopping-analytics-service
fetchProject ${tutorial_sources}/00-shopping-order-service-scala shopping-order-service
zipAndAttach ${tutorial_attachments}/2-shopping-cart-event-sourced-scala.zip ${tutorial_temporal_attachments}

## complete entity
prepareTemporalFolder
fetchProject ${tutorial_sources}/03-shopping-cart-service-scala shopping-cart-service
fetchProject ${tutorial_sources}/00-shopping-analytics-service-scala shopping-analytics-service
fetchProject ${tutorial_sources}/00-shopping-order-service-scala shopping-order-service
zipAndAttach ${tutorial_attachments}/3-shopping-cart-event-sourced-complete-scala.zip ${tutorial_temporal_attachments}

## projection query
prepareTemporalFolder
fetchProject ${tutorial_sources}/04-shopping-cart-service-scala shopping-cart-service
fetchProject ${tutorial_sources}/00-shopping-analytics-service-scala shopping-analytics-service
fetchProject ${tutorial_sources}/00-shopping-order-service-scala shopping-order-service
zipAndAttach ${tutorial_attachments}/4-shopping-cart-projection-scala.zip ${tutorial_temporal_attachments}

## projection kafka
prepareTemporalFolder
fetchProject ${tutorial_sources}/05-shopping-cart-service-scala shopping-cart-service
fetchProject ${tutorial_sources}/shopping-analytics-service-scala shopping-analytics-service
fetchProject ${tutorial_sources}/00-shopping-order-service-scala shopping-order-service
zipAndAttach ${tutorial_attachments}/5-shopping-cart-projection-kafka-scala.zip ${tutorial_temporal_attachments}

## complete
prepareTemporalFolder
fetchProject ${tutorial_sources}/shopping-cart-service-scala shopping-cart-service
fetchProject ${tutorial_sources}/shopping-analytics-service-scala shopping-analytics-service
fetchProject ${tutorial_sources}/shopping-order-service-scala shopping-order-service
zipAndAttach ${tutorial_attachments}/6-shopping-cart-complete-scala.zip ${tutorial_temporal_attachments}

## how-to Cassandra
prepareTemporalFolder
fetchProject ${howto_sources}/shopping-cart-service-cassandra-scala shopping-cart-service
zipAndAttach ${howto_attachments}/shopping-cart-cassandra-scala.zip ${howto_temporal_attachments}


## Java Zip files
## empty seed template
prepareTemporalFolder
fetchProject ${tutorial_sources}/00-shopping-cart-service-java shopping-cart-service
fetchProject ${tutorial_sources}/00-shopping-analytics-service-java shopping-analytics-service
fetchProject ${tutorial_sources}/00-shopping-order-service-java shopping-order-service
zipAndAttach ${tutorial_attachments}/0-shopping-cart-start-java.zip ${tutorial_temporal_attachments}

## gRPC service
prepareTemporalFolder
fetchProject ${tutorial_sources}/01-shopping-cart-service-java shopping-cart-service
fetchProject ${tutorial_sources}/00-shopping-analytics-service-java shopping-analytics-service
fetchProject ${tutorial_sources}/00-shopping-order-service-java shopping-order-service
zipAndAttach ${tutorial_attachments}/1-shopping-cart-grpc-java.zip ${tutorial_temporal_attachments}

## basic entity
prepareTemporalFolder
fetchProject ${tutorial_sources}/02-shopping-cart-service-java shopping-cart-service
fetchProject ${tutorial_sources}/00-shopping-analytics-service-java shopping-analytics-service
fetchProject ${tutorial_sources}/00-shopping-order-service-java shopping-order-service
zipAndAttach ${tutorial_attachments}/2-shopping-cart-event-sourced-java.zip ${tutorial_temporal_attachments}

## complete entity
prepareTemporalFolder
fetchProject ${tutorial_sources}/03-shopping-cart-service-java shopping-cart-service
fetchProject ${tutorial_sources}/00-shopping-analytics-service-java shopping-analytics-service
fetchProject ${tutorial_sources}/00-shopping-order-service-java shopping-order-service
zipAndAttach ${tutorial_attachments}/3-shopping-cart-event-sourced-complete-java.zip ${tutorial_temporal_attachments}

## projection query
prepareTemporalFolder
fetchProject ${tutorial_sources}/04-shopping-cart-service-java shopping-cart-service
fetchProject ${tutorial_sources}/00-shopping-analytics-service-java shopping-analytics-service
fetchProject ${tutorial_sources}/00-shopping-order-service-java shopping-order-service
zipAndAttach ${tutorial_attachments}/4-shopping-cart-projection-java.zip ${tutorial_temporal_attachments}

## projection kafka
prepareTemporalFolder
fetchProject ${tutorial_sources}/05-shopping-cart-service-java shopping-cart-service
fetchProject ${tutorial_sources}/shopping-analytics-service-java shopping-analytics-service
fetchProject ${tutorial_sources}/00-shopping-order-service-java shopping-order-service
zipAndAttach ${tutorial_attachments}/5-shopping-cart-projection-kafka-java.zip ${tutorial_temporal_attachments}

## complete
prepareTemporalFolder
fetchProject ${tutorial_sources}/shopping-cart-service-java shopping-cart-service
fetchProject ${tutorial_sources}/shopping-analytics-service-java shopping-analytics-service
fetchProject ${tutorial_sources}/shopping-order-service-java shopping-order-service
zipAndAttach ${tutorial_attachments}/6-shopping-cart-complete-java.zip ${tutorial_temporal_attachments}

## how-to Cassandra
prepareTemporalFolder
fetchProject ${howto_sources}/shopping-cart-service-cassandra-java shopping-cart-service
zipAndAttach ${howto_attachments}/shopping-cart-cassandra-java.zip ${howto_temporal_attachments}
