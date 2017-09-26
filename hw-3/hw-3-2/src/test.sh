#!/bin/bash
RAND=$(($RANDOM % 127))
RANDM=$(($RAND - 1))
java UnsafeMemory BetterSorry 32 10 $RAND $RANDM $RANDM $RANDM $RANDM $RANDM $RANDM $RANDM;
