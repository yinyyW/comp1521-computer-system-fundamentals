# COMP1521 18s1 Ass1 test 10 ... draws original state of max length worm

~cs1521/bin/spim -file worm.s 39 0 1 | \
    sed -e 's/^.*Iteration/Iteration/;s/  *$//;/Loaded:/d'
