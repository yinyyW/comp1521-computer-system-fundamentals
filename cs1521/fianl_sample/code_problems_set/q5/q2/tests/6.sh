rm -f tests/s6.dat
if ./mkstu tests/stu6 tests/s6.dat
then
    if [ -f tests/s6.dat ]
    then
        ./stu tests/s6.dat
    fi
fi
