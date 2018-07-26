rm -f tests/s1.dat
if ./mkstu tests/stu1 tests/s1.dat
then
	if [ -f tests/s1.dat ]
	then
		./stu tests/s1.dat
	fi
fi
