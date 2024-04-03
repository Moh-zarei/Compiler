%{
    
    #include <ctype.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include<string.h>
    int yylex();
    int yyerror(char*);
    
    int countDigits(int n); 
    int isfound(char* num , char digit);
    int sum_digits(char* num);
    char* gen(char* res , char* first_operand , char* second_operand , char* operator);
    char * SUB(char* num1, char* num2);
    char * ADDER(char* num1 , char* num2);
    char * MULT(char* num1 , char* num2);
    char * DIV(char* num1 , char* num2);

    int t = 0;

%}


%union{
    char* op;
    struct var_name {
		char* value; 
		char* t;
	} tk;
}

%token EOL
%token<tk> Number
%token<op> MULTIPLY DIVIDE
%token<op> ADD SUBTRACT
%type<tk> line expr term factor
%left ADD SUBTRACT
%left MULTIPLY DIVIDE

%%  /* rules */

line : expr '=' EOL {YYACCEPT;} 

expr : expr ADD term {$$.value = ADDER($1.value , $3.value);    $$.t = gen($$.value , $1.t , $3.t , $2);}
     | expr SUBTRACT term {$$.value = SUB($1.value , $3.value); $$.t = gen($$.value , $1.t , $3.t , $2);}
     | term {$$.value = $1.value;}

term : term MULTIPLY factor {$$.value = MULT($1.value , $3.value); $$.t = gen($$.value , $1.t , $3.t , $2);}
     | term DIVIDE factor {$$.value = DIV($1.value , $3.value);    $$.t = gen($$.value , $1.t , $3.t , $2);}
     | factor {$$.value = $1.value;}

factor : Number {$$.value = $1.value; $$.t = $$.value;}
       | '(' expr ')'   {$$.value = $2.value; $$.t = $2.t;}

%%

int main(){
    printf("Enter input : ");
    while(yyparse());

    return 0;
}

int yyerror(char *error){
    printf("Error Occured: %s\n", error);
    return 0;
}

char* gen(char* res , char* first_operand , char* second_operand , char* operator){
    char* temp = malloc(countDigits(t) + 2 + 1);
    sprintf(temp,"t%d",++t);
    printf("%s = %s %s %s;\n", temp, first_operand , operator , second_operand);
    printf("%s = %s;\n", temp , res);
    return temp;
}

char* SUB(char* num1, char* num2) {
    int hash[10] = {0};
    int i = 0;
    char *result = malloc(strlen(num1));
    strcpy(result , num1);
    while(num2[i] != '\0') {
        hash[num2[i] - '0'] = 1;
        i++;
    }

    i = 0;
    int j = 0;
    while(result[i] != '\0') {
        if(hash[result[i] - '0'] == 0) {
            result[j] = result[i];
            j++;
        }
        i++;
    }
    result[j] = '\0';
    return result;
}

char * ADDER(char* num1 , char* num2){
    int len1 = strlen(num1);
    int len2 = strlen(num2);
    char *result = malloc(strlen(num1));
    strcpy(result , num1);
    char *repeatedDigits = malloc(strlen(num2)) ;
    int index = 0;
    for(int i = 0; i < len2; i++) {
        int found = 0;
        for(int j = 0; j < len1; j++) {
            if(num2[i] == num1[j]) {
                found = 1;
                break;
            }
        }
        if (!found)
            repeatedDigits[index++] = num2[i];
    }
    repeatedDigits[index] = '\0';
    for (index = 0 ; repeatedDigits[index] != '\0' ; index++){
        result[len1++] = repeatedDigits[index];
    }
    free(repeatedDigits);
    result[len1] = '\0';
    return result;
}

char* MULT(char* num1 , char* num2){
    int sum = sum_digits(num2);
    int len = strlen(num1);
    if (isfound(num1 , sum + '0')){
        num1[len] = sum + '0';
    }
    num1[len + 1]='\0';
    return num1;
}

char* DIV(char* num1 , char* num2){
    int sum = sum_digits(num2);
    
    int len1 = strlen(num1);
    int j = 0;

    for(int i = 0; i < len1; i++) {
        if(num1[i] != sum + '0') {
            num1[j++] = num1[i];
        }
    }
    num1[j] = '\0';
    return num1;
}

int sum_digits(char* num){
    int len = strlen(num);
    char* number = malloc(len);
    strcpy(number , num);
    int sum = 0;

    do {
        sum = 0;
        for(int i = 0; i < len; i++)
            sum += number[i] - '0';
        sprintf(number, "%d", sum);
        len = strlen(number);
    } while(sum >= 10);
    return sum;
}

int isfound(char* num , char digit){
    for (int i = 0; num[i] != '\0' ; i++){
        if (num[i] == digit)
            return 0;
    }
    return 1;
}

int countDigits(int n) {
    if (n == 0) {return 0;}
    else {return 1 + countDigits(n / 10);}
}

