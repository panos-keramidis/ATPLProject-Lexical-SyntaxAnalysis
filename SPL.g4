grammar SPL;

stat : Head \n Var? \n Body ;

Head : 'PROGRAM ' IDENTIFIERS ;

Var : 'VAR' LineOfVar* LastLineOfVar ; 
LastLineOfVar : \n \t IDENTIFIERS [' ,' IDENTIFIERS]* ' ' ID_TYPE ' ' idtype ;
idtypeBasic : 'INTEGER' | 'STRING' | 'BOOLEAN' ;
idtype : idtypeBasic | arraytype ;
arraytype : 'ARRAY' L_BRACK index R_BRACK 'OF' idtypeBasic ;
index : [0-9]+ ;
LineOfVar : LastLineOfVar ' ;' ;

Body : 'BODY' Block ;
Block : \n \t Block 
		| \n 'BEGIN' [\n \t statement ' ;']* \n \t statement \n 'END';
statement :  Assignment
			| Read
			| Write
			| IfThenElse
			| WhileDo
			| Exit ;
Assignment : lvalue ASSIGNMENT expr ;
lvalue : metavliti
		| stoixeiopinaka ;
metavliti : IDENTIFIERS ; 
stoixeiopinaka : IDENTIFIERS L_BRACK deiktis R_BRACK ;
deiktis : index 
		| IDENTIFIERS ;
Read : 'READ' L_PARENTHESES IDENTIFIERS [SEP_LIST ' ' IDENTIFIERS]* R_PARENTHESES ';';
Write : 'WRITE' L_PARENTHESES orisma [SEP_LIST ' ' orisma]* R_PARENTHESES ';';
orisma : '"' CHARACTER_SET+ '"' 
		| IDENTIFIERS 
		| expr;
IfThenElse : 'IF ' expr ' THEN ' statement [else]? ' ;';
else : \n 'ELSE ' IfThenElse
		| \n 'ELSE ' statement ;
WhileDo : 'WHILE ' expr ' DO' \n \t Block ;
Exit : EOF;

expr : L_PARENTHESES? expr R_PARENTHESES?
		| expr OPERATORS expr
		| IDENTIFIERS
		| CONSTANTS
		| stoixeiopinaka ;


CHARACTER_SET : [' '!"'#$%^&*()~+\.-,.<>/?\|;[]{}:=`0-9a-zA-Z_] ;
WHITESPACES : [ \t\n] ;
COMMENTS : '{' .*? ^'\n' '}' ; 
IDENTIFIERS : [a-zA-Z_][a-zA-Z_0-9]+ ;
CONSTANTS : [-]?[0-9'TRUE''FALSE'ALPHARITHMETIC]+ ;
ALPHARITHMETIC : '"'  [a-zA-Z'\″''\\'] '"' ; 
OPERATORS : [UNARY_MINUS, MULTIPLICATIVE, ADDITIVE, RELATIONAL, LOGICAL, CONCATENATION, ASSIGNMENT] ;
UNARY_MINUS : '-' ;
MULTIPLICATIVE : '*' | '/' | '%' ;
ADDITIVE : '+' | '-' ;
RELATIONAL : '=', '<>', '<', '>', '<=', '>=' ;
LOGICAL : 'AND' | 'OR' | 'NOT' ;
CONCATENATION : '|' ;
ASSIGNMENT : ':=' ;
PUNCTUATORS : [GROUPING, ARRAY, SEP, ID_TYPE, SEP_LIST] ;
GROUPING : [L_PARENTHESES, R_PARENTHESES] ;
L_PARENTHESES : '(' ;
R_PARENTHESES : ')' ;
ARRAY : [L_BRACK, R_BRACK] ;
L_BRACK : '[' ;
R_BRACK : ']' ;
SEP : ';' ;
ID_TYPE : ':' ;
SEP_LIST : ',' ;
