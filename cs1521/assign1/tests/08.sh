# COMP1521 18s1 Ass1 test 08 ... completes 30 moves, reaches edges and corners

~cs1521/bin/spim -file worm.s 30 30 18 | \
    sed -e 's/^.*Iteration/Iteration/;s/  *$//;/Loaded:/d'
