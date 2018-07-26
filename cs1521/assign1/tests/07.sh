# COMP1521 18s1 Ass1 test 07 ... gets blocked after 16 moves

~cs1521/bin/spim -file worm.s 30 30 4 | \
    sed -e 's/^.*Iteration/Iteration/;s/  *$//;/Loaded:/d'
