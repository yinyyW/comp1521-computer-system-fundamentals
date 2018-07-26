rm -f tests/s5.dat
if ./mkstu tests/stu5 x/y
then
    if [ -f tests/s5.dat ]
    then
        ./stu tests/s5.dat
    fi
fi
