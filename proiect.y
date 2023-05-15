%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    char* substr(const char *src, int m, int n);
    char str_create[1000];
    char str_where[1000];
    char str_insert[1000];
    char str_insert_values[1000];
    char str_set[1000];
%}

%start instruction
%union {char *word;}
%token <word> CREATE DROP DELETE INSERT INTO VALUES FROM WHERE TABLE WORD AND OR ALTER COLUMN MODIFY RENAME ADD TO UPDATE SET
%type <word> wordsCreate 
%type <word> wordsWhere
%type <word> wordsInsert wordsInsertValues 
%type <word> wordsSet
%type <word> delete where alter
%left ')' '(' ';' ',' '=' '>' '<'


%%
instruction : instruction create                      {strcpy(str_create, "");}
            | instruction drop
            | instruction delete                      {strcpy(str_where, "");}
            | instruction insert                      {
                                                       strcpy(str_insert, ""); 
                                                       strcpy(str_insert_values, "");
                                                      }
            | instruction alter
            | instruction update                      {strcpy(str_where, ""); strcpy(str_set, "");}
            | /* EMPTY */
            ;

create : CREATE TABLE WORD '(' wordsCreate ')' ';'   { printf("Create the table named %s that has the following columns, respectively date types: %s.\n", $3, str_create);
                                                     
                                                     }
       ;

drop : DROP TABLE WORD ';'                           { printf("Delete the table named %s.\n", $3);}
     ;

delete : DELETE FROM WORD where ';'                  {  char strAux[100];
                                                        for(int i = 0; i < strlen($3); i++){ 
                                                            char c = tolower($3[i]);
                                                            //printf("Fiecare caracter c %c\n", c);
                                                            strAux[i] = c;
                                                            //strcat(strAux, c);
                                                        }
                                                        printf("Delete all %s who have %s from the table.\n", strAux, str_where);
                                                     }
       | DELETE FROM WORD ';'                        {  
                                                        char strAux[100];
                                                        for(int i = 0; i < strlen($3); i++){
                                                            char c = tolower($3[i]);
                                                            //printf("Fiecare caracter %c\n", c);
                                                            strAux[i] = c;
                                                            //strcat(strAux, c);
                                                        }
                                                        printf("Delete all %s from the table.\n", strAux);
                                                     }
       ;

insert : INSERT INTO WORD '(' wordsInsert ')' VALUES '(' wordsInsertValues ')' ';'           { char strAux[100];
                                                                                               for(int i = 0; i < strlen($3); i++){
                                                                                                    char c = tolower($3[i]);
                                                                                                    strAux[i] = c;
                                                                                               }

                                                                                               if(strAux[strlen(strAux) - 1] == 's' && strAux[strlen(strAux) - 2] != 's'){
                                                                                                    char *s = substr(strAux, 0, strlen($3) - 1);
                                                                                                    printf("Add the following %s to the table: %s.\n", s, str_insert_values);
                                                                                               }
                                                                                               else
                                                                                               {
                                                                                                    printf("Add the following %s to the table: %s.\n", $3, str_insert_values);
                                                                                               }
                                                                                             }
       | INSERT INTO WORD VALUES '(' wordsInsertValues ')' ';'                               { char strAux[100];
                                                                                               for(int i = 0; i < strlen($3); i++){
                                                                                                    char c = tolower($3[i]);
                                                                                                    strAux[i] = c;
                                                                                               }

                                                                                               if(strAux[strlen(strAux) - 1] == 's' && strAux[strlen(strAux) - 2] != 's'){
                                                                                                    char *s = substr(strAux, 0, strlen($3) - 1);
                                                                                                    printf("Add the following %s to the table: %s.\n", s, str_insert_values);
                                                                                               }
                                                                                               else
                                                                                               {
                                                                                                    printf("Add the following %s to the table: %s.\n", $3, str_insert_values);
                                                                                               }
                                                                                             }
       ;

where : WHERE wordsWhere                             { }
      ;

alter : ALTER TABLE WORD ADD WORD WORD ';'               { printf("Add to the %s table the column with the name %s and the data type %s.\n", $3, $5, $6);}
      | ALTER TABLE WORD DROP COLUMN WORD ';'            { printf("Delete column %s from table %s.\n", $6, $3);}
      | ALTER TABLE WORD RENAME COLUMN WORD TO WORD ';'  { printf("Rename column %s with name %s from table %s.\n", $6, $8, $3);}
      | ALTER TABLE WORD ALTER COLUMN WORD WORD ';'      { printf("Change the data type of column %s to %s in table %s.\n", $6, $7, $3);}
      | ALTER TABLE WORD MODIFY COLUMN WORD WORD ';'     { printf("Change the data type of column %s to %s in table %s.\n", $6, $7, $3);}
      | ALTER TABLE WORD MODIFY WORD WORD ';'            { printf("Change the data type of column %s to %s in table %s.\n", $5, $6, $3);}
      ;

update : UPDATE WORD set where ';'                       { printf("Modify the %s table so that %s for the element that has %s.\n", $2, str_set, str_where);}
       | UPDATE WORD set ';'
       ;

set : SET wordsSet                                       {}
    ;

wordsSet : WORD '=' WORD                                 {
                                                           strcat(str_set, "column ");
                                                           strcat(str_set, $1);
                                                           strcat(str_set, " to have the value ");
                                                           strcat(str_set, $3);
                                                           strcat(str_set, ", ");
                                                         }
         | wordsSet ',' wordsSet
         ;

wordsInsert : WORD                                      {
                                                          strcat(str_insert, $1);
                                                          strcat(str_insert, " ");
                                                        }
            | wordsInsert ',' wordsInsert
            ;

wordsInsertValues : WORD                                {
                                                            strcat(str_insert_values, $1);
                                                            strcat(str_insert_values, " ");
                                                        }
                  | wordsInsertValues ',' wordsInsertValues
                  ;

wordsWhere : WORD '=' WORD                           { //aici tine mai mult de where si cum il construim
                                                        strcat(str_where, $1);
                                                        strcat(str_where, " equal to ");
                                                        strcat(str_where, $3);
                                                        //strcpy($$, str_where);
                                                        //printf("Suntem in interiorul lui where %s\n", str_where);

                                                     }
           | wordsWhere AND wordsWhere
           | wordsWhere OR wordsWhere
           ;

wordsCreate : WORD WORD                              { 
                                                       strcat(str_create, $1);
                                                       strcat(str_create, " ");
                                                       strcat(str_create, $2);
                                                       strcat(str_create, " ");
                                                       //printf("%s\n", str);
                                                       //strcpy($$, str); 
                                                       //printf("%s\n", $$);
                                                     }
            | wordsCreate ',' wordsCreate
            ;
%%


// char* substr(const char *src, int m, int n)
// {
//     int len = n - m;
//     char *dest = (char*)malloc(sizeof(char) * (len + 1));
 
//     for (int i = m; i < n && (*(src + i) != '\0'); i++)
//     {
//         *dest = *(src + i);
//         dest++;
//     }
 
//     *dest = '\0';
 
//     return dest - len;
// }


int main(){
    yyparse();
    return 0;
}

yyerror(){
    ;
}
