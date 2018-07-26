# COMP1521 18s1 Ass1 test 03 ... wiggles a bit, completes 5 iterations

~cs1521/bin/spim -file worm.s 10 5 123 | \
    sed -e 's/^.*Iteration/Iteration/;s/  *$//;/Loaded:/d'
