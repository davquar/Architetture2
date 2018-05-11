#!/bin/bash

programFile="exercise03.asm"
marsPath="../../MARS.jar"
testsDir="tests"

for inputFile in `ls $testsDir/*.in`; do
    printf "Testing ${inputFile/$testsDir\//}:\t"
    outputFile=$inputFile.out
    referenceFile=`echo ${inputFile/.in/.out}`
    java -jar $marsPath me nc sm ic $programFile < $inputFile > $outputFile 2> /dev/null
    diffs=`diff $outputFile $referenceFile`
    if [[ $diffs == "" ]]; then
        printf "[OK]\n"
    else
        printf "[FAILED]\n"
    fi
done
