// This file was formatted with the help of agentic AI.

grammar SmallGrammar;

// ============================================================================
// Lexer rules
// ============================================================================

// --- Keywords ---------------------------------------------------------------

IF            : 'if';
ELSE          : 'else';
WHILE         : 'while';
FUNCTION      : 'function';
RETURN        : 'return';

// --- Separators and punctuation --------------------------------------------

LBRACE        : '{';
RBRACE        : '}';
LPAR          : '(';
RPAR          : ')';
COMMA         : ',';
SEMICOLON     : ';';

// --- Operators --------------------------------------------------------------

ASSIGN        : '=';
AND           : 'and';
OR            : 'or';
ADD           : '+';
SUBSTRACT     : '-';
MULTIPLY      : '*';
DIVIDE        : '/';
GREATER       : '>';
GREATER_EQUAL : '>=';
LESS          : '<';
LESS_EQUAL    : '<=';
EQUAL         : '==';
NOT_EQUAL     : '!=';

// --- Literals ---------------------------------------------------------------

TRUE          : 'True';
FALSE         : 'False';

fragment DIGIT: [0-9];
NUM           : DIGIT+;

// --- Identifiers ------------------------------------------------------------

fragment LETTER: [a-zA-Z];
IDENTIFIER    : LETTER (LETTER | DIGIT)*;

// --- Ignored comments and whitespace ---------------------------------------

COMMENT       : ('/*' (.*?) '*/' | '//' .*? '\r'? ('\n' | EOF)) -> skip;

NEWLINE       : '\r'? '\n' -> skip;
WS            : [ \t]+ -> skip;

// ============================================================================
// Parser rules
// ============================================================================

// --- Program ----------------------------------------------------------------

program: function*;

function: FUNCTION IDENTIFIER LPAR parameters RPAR body;

parameters: (IDENTIFIER (COMMA IDENTIFIER)*)?;

// --- Statements -------------------------------------------------------------

body: LBRACE stmt* RBRACE;

stmt:
    assignStmt
    | ifStmt
    | whileStmt
    | returnStmt
;

assignStmt: IDENTIFIER ASSIGN (expr | funcCall) SEMICOLON;

ifStmt: IF LPAR boolExpr RPAR ifBody = body ELSE elseBody = body;

whileStmt: WHILE LPAR boolExpr RPAR body;

returnStmt: RETURN expr SEMICOLON;

// --- Function calls ---------------------------------------------------------

funcCall: IDENTIFIER LPAR arguments RPAR;

arguments: (expr (COMMA expr)*)?;

// --- Expressions ------------------------------------------------------------

expr:
    arithExpr
    | boolExpr
;

arithExpr:
    noprnd
    | binArithOp
;

boolExpr:
    boprnd
    | relOp
    | binLogicOp
;

binArithOp: left = noprnd arithOp right = noprnd;

binLogicOp: left = noprnd logicOp right = noprnd;

relOp: left = boprnd nop right = boprnd;

noprnd:
    IDENTIFIER
    | NUM
;

boprnd:
    IDENTIFIER
    | TRUE
    | FALSE
;

// --- Operators --------------------------------------------------------------

arithOp:
    ADD
    | SUBSTRACT
    | MULTIPLY
    | DIVIDE
;

logicOp:
    LESS
    | GREATER
    | EQUAL
    | NOT_EQUAL
    | GREATER_EQUAL
    | LESS_EQUAL
;

nop:
    EQUAL
    | NOT_EQUAL
    | AND
    | OR
;
