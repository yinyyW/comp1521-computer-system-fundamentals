rm -f tests/s8.dat
if ./mkstu tests/stu8 tests/s8.dat
then
    if [ -f tests/s8.dat ]
    then
        ./stu tests/s8.dat
    fi
fi
