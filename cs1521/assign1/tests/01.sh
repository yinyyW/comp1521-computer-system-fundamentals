# COMP1521 18s1 Ass1 test 01 ... just draw original 5-segment worm

~cs1521/bin/spim -file worm.s 5 0 37 | \
    sed -e 's/^.*Iteration/Iteration/;s/  *$//;/Loaded:/d'
