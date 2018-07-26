rm -f tests/s4.dat
if ./mkstu abc tests/s4.dat
then
    if [ -f tests/s4.dat ]
    then
        ./stu tests/s4.dat
    fi
fi
