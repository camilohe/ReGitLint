#!/bin/bash
dotnet tool restore

# give everyone write permissions
# without doing this I recieved the following error from jb
#
#   error: Files still read-only: /srv/Tests/HelloWorld/Program.cs
sudo chmod -R 777 .

failedTests=0

for d in */ ; do

    test_script="$d/test.sh"

    if test -f "$test_script"; then

        echo "running test $d"

        "$d/test.sh" "net6.0"

        if [ $? -ne 0 ]; then
            echo "$d failed"
            failedTests=$(($failedTests + 1))
        fi

        git restore HelloWorld/
    fi

    #../ReGitLint/bin/Release/$1/ReGitLint
    #diff HelloWorld/Program.cs FormatEntireSln/Expected/Program.cs
done

if (($failedTests > 0)); then
    echo "$failedTests tests failed"
    exit 1
fi
