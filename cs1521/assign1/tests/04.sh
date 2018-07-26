# COMP1521 18s1 Ass1 test 04 ... wiggles a bit, completes 10 iterations

~cs1521/bin/spim -file worm.s 10 10 13 | \
    sed -e 's/^.*Iteration/Iteration/;s/  *$//;/Loaded:/d'
