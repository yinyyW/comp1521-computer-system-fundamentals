# COMP1521 18s1 Ass1 test 05 ... runs towards bottom in 15 iterations

~cs1521/bin/spim -file worm.s 10 15 31 | \
    sed -e 's/^.*Iteration/Iteration/;s/  *$//;/Loaded:/d'
