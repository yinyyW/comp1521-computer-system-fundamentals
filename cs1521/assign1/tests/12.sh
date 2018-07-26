# COMP1521 18s1 Ass1 test 12 ... shows 39-segment worm after 2 moves

~cs1521/bin/spim -file worm.s 39 2 1 | \
    sed -e 's/^.*Iteration/Iteration/;s/  *$//;/Loaded:/d'
