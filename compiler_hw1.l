/*
    filename: compiler_hw1.l
*/

/* Definition section */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #define YY_NO_UNPUT
    #define YY_NO_INPUT
    #define print_token(token) \
        printf("%-8s \t %s\n", strcmp(token, "NEWLINE")? yytext: "", token)

    int line_num = 0;
    int comment_num = 0;
    int last_comment_line = -1;
%}


/* Define regular expression label */
letter [a-zA-Z_]
digit [0-9]
id {letter}+({letter}|{digit})*
inumber {digit}+
fnumber ({digit}*\.{digit}+)

/* Define start conditions */
%x STR_LIT C_COMMENT CPP_COMMENT


/* Rules section */
%%

"print"		{ print_token("PRINT"); }
"println"	{ print_token("PRINTLN"); }
"if"		{ print_token("IF"); }
"else"		{ print_token("ELSE"); }
"for"		{ print_token("FOR"); }
"int32"		{ print_token("INT"); }
"float32"	{ print_token("FLOAT"); }
"string"	{ print_token("STRING"); }
"bool"		{ print_token("BOOL"); }
"true"		{ print_token("TRUE"); }
"false"		{ print_token("FALSE"); }
"var"		{ print_token("VAR"); }
"func"		{ print_token("FUNC"); }
"package"	{ print_token("PACKAGE"); }
"return"	{ print_token("RETURN"); }
"switch"	{ print_token("SWITCH"); }
"case"		{ print_token("CASE"); }
"default"	{ print_token("DEFAULT"); }

"+"         { print_token("ADD"); }
"-"         { print_token("SUB"); }
"*"         { print_token("MUL"); }
"/"         { print_token("QUO"); }
"%"         { print_token("REM"); }
"++"        { print_token("INC"); }
"--"        { print_token("DEC"); }
">"         { print_token("GTR"); }
"<"         { print_token("LSS"); }
">="        { print_token("GEQ"); }
"<="        { print_token("LEQ"); }
"=="        { print_token("EQL"); }
"!="        { print_token("NEQ"); }
"="         { print_token("ASSIGN"); }
"+="        { print_token("ADD_ASSIGN"); }
"-="        { print_token("SUB_ASSIGN"); }
"*="        { print_token("MUL_ASSIGN"); }
"/="        { print_token("QUO_ASSIGN"); }
"%="        { print_token("REM_ASSIGN"); }
"&&"        { print_token("LAND"); }
"||"        { print_token("LOR"); }
"!"			{ print_token("NOT"); }
"("			{ print_token("LPAREN"); }
")"			{ print_token("RPAREN"); }
"["			{ print_token("LBRACK"); }
"]"			{ print_token("RBRACK"); }
"{"			{ print_token("LBRACE"); }
"}"			{ print_token("RBRACE"); }
";"			{ print_token("SEMICOLON"); }
","			{ print_token("COMMA"); }
"\n"		{ print_token("NEWLINE"); line_num++; }
":"			{ print_token("COLON"); }

{inumber}	{ print_token("INT_LIT"); }
{fnumber}	{ print_token("FLOAT_LIT"); }
{id}        { print_token("IDENT"); }

"\""				{ print_token("QUOTA"); BEGIN(STR_LIT); }
<STR_LIT>[^"\n]*	{ print_token("STRING_LIT"); }
<STR_LIT>"\""		{ print_token("QUOTA"); BEGIN(INITIAL); }

"//"[^\n]*			{ print_token("C++ Comment"); BEGIN(CPP_COMMENT); }
<CPP_COMMENT>"\n"	{ print_token("NEWLINE"); line_num++, comment_num++; BEGIN(INITIAL); }

"/*"				{ ECHO; BEGIN(C_COMMENT); }
<C_COMMENT>"*/"		{ print_token("C Comment"); comment_num++; BEGIN(INITIAL); }
<C_COMMENT>"\n"		{ print_token("C Comment"); line_num++, comment_num++; }
<C_COMMENT>.		{ ECHO; }

<<EOF>>     { line_num++; yyterminate(); }
[ \t]+      {;}
.           {;}
%%

/*  C Code section */
int yywrap(void)
{
    return 1;
}

int main(int argc, char *argv[])
{
    if (argc == 2) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }
    yylex();
    printf("\nFinish scanning,\n");
    printf("total line: %d\n", line_num);
    printf("comment line: %d\n", comment_num);
    fclose(yyin);
    return 0;
}
