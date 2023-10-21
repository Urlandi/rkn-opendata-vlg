# Concat
:start
/<rkn:territory>/b print;
$b print;

N;
s/>\s*\r\n/>,/;
b start;


:print
s/\n/ /g;
s/^\s\s*//;
s/>,\s\s*</>,</g;
p;
