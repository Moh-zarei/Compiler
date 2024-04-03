%{
    #include <string.h>
    #include "y.tab.h"
    
    char* match(); 
%}


letter [A-Za-z]
digit [0-9]
number {digit}+(\.{digit}+)?(E[+\-]?{digit}+)?

%%

=     { return '='; }
\(    {return '('; }
\)    {return ')'; }
"+"   { yylval.op = match(); return ADD; }
"-"   { yylval.op = match(); return SUBTRACT;}
"*"   { yylval.op = match(); return MULTIPLY; }
"/"   { yylval.op = match(); return DIVIDE; }

{number} {
    yylval.tk.value =match();
    return Number;
}

\n {return EOL;}
. {}

%%

int yywrap() {}

char* match() 
{
    char *text = malloc(11);
    strcpy(text, yytext);
    return text;
}