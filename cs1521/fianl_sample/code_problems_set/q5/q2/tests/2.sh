rm -f tests/s2.dat
if ./mkstu tests/stu2 tests/s2.dat
then
	if [ -f tests/s2.dat ]
	then
		./stu tests/s2.dat
	fi
fi
