# COMP1521 18s1 Ass1 test 02 ... a 5-segment that wiggles straight-ish-ly

~cs1521/bin/spim -file worm.s 5 5 37 | \
    sed -e 's/^.*Iteration/Iteration/;s/  *$//;/Loaded:/d'
