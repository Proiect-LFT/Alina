%{
    #include "y.tab.c"
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    char* substr(const char *src, int m, int n);
%}

%%
[ \t\n]                                       ;
("CREATE"|"create")                           {return CREATE;}
("DROP"|"drop")                               {return DROP;}
("DELETE"|"delete")                           {return DELETE;}
("INSERT"|"insert")                           {return INSERT;}
("INTO"|"into")                               {return INTO;}
("VALUES"|"values")                           {return VALUES;}
("ALTER"|"alter")                             {return ALTER;}
("ADD"|"add")                                 {return ADD;}
("RENAME"|"rename")                           {return RENAME;}
("COLUMN"|"column")                           {return COLUMN;}
("MODIFY"|"modify")                           {return MODIFY;}
("UPDATE"|"update")                           {return UPDATE;}
("SET"|"set")                                 {return SET;}
("FROM"|"from")                               {return FROM;}
("WHERE"|"where")                             {return WHERE;}
("TABLE"|"table")                             {return TABLE;}
("AND"|"and")                                 {return AND;}
("OR"|"or")                                   {return OR;}
("TO"|"to")                                   {return TO;}
\(                                            {return '(';}
\)                                            {return ')';}
\'?\"?[a-zA-Z0-9\.\(\)\-\_]+\'?\"?              {
                                                if(yytext[0] == '\'' || yytext[0] == '"') {
                                                    //printf("Verificam %s\n", substr(yytext, 1, yyleng - 1));
                                                    yylval.word = strdup(substr(yytext, 1, yyleng-1)); 
                                                } else {
                                                    yylval.word = strdup(yytext); 
                                                }
                                                
                                                return WORD;
                                              } //nu imi ia si cuvintele compuse -- am o idee
\;                                            {return ';';}
\,                                            {return ',';}
\=                                            {return '=';}
\<                                            {return '<';}
\>                                            {return '>';}


%%

char* substr(const char *src, int m, int n)
{
    int len = n - m;
    char *dest = (char*)malloc(sizeof(char) * (len + 1));
 
    for (int i = m; i < n && (*(src + i) != '\0'); i++)
    {
        *dest = *(src + i);
        dest++;
    }
 
    *dest = '\0';
 
    return dest - len;
}

