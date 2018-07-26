# COMP1521 18s1 Ass1 test 06 ... runs for 15 iteration and wiggles a lot

~cs1521/bin/spim -file worm.s 20 15 17 | \
    sed -e 's/^.*Iteration/Iteration/;s/  *$//;/Loaded:/d'
