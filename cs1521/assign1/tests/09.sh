# COMP1521 18s1 Ass1 test 09 ... completes 30 moves, reaches edges and corner

~cs1521/bin/spim -file worm.s 33 30 37 | \
    sed -e 's/^.*Iteration/Iteration/;s/  *$//;/Loaded:/d'
