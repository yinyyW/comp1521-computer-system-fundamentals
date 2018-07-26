# COMP1521 18s1 Ass1 test 13 ... 39-segment worm which completes 20 iterations

~cs1521/bin/spim -file worm.s 39 20 15 | \
    sed -e 's/^.*Iteration/Iteration/;s/  *$//;/Loaded:/d'
