# Concat
:start

/,--$/b print;

N;
s/\n/,/g; t start;

:print
s/,--$//g
p;