rm -f tests/s7.dat
if ./mkstu tests/stu7 tests/s7.dat
then
    if [ -f tests/s7.dat ]
    then
        ./stu tests/s7.dat
    fi
fi
