# COMP1521 18s1 Ass1 test 11 ... shows 30-segment worm after first move

~cs1521/bin/spim -file worm.s 39 1 1 | \
    sed -e 's/^.*Iteration/Iteration/;s/  *$//;/Loaded:/d'
