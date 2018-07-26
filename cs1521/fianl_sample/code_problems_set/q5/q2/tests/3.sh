rm -f tests/s3.dat
if ./mkstu tests/stu3 tests/s3.dat
then
    if [ -f tests/s3.dat ]
    then
        ./stu tests/s3.dat
    fi
fi

