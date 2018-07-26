# COMP1521 18s1 Ass1 test 14 ... 39-segment worm that blocks after 10 moves

~cs1521/bin/spim -file worm.s 39 30 53 | \
    sed -e 's/^.*Iteration/Iteration/;s/  *$//;/Loaded:/d'
