/*
 * Copyright © 2017-2019 Cask Data, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

grammar Directives;

options {
  language = Java;
}

@lexer::header {
/*
 * Copyright © 2017-2019 Cask Data, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
}

recipe
 : statements EOF
 ;

statements
 : ( statement )*
 ;

statement
 : directive ';'
 | pragma ';'
 | ifStatement
 | forStatement
 | macro
 | Comment
 ;

directive
 : command (directiveArgument)*?
 ;

directiveArgument
 : codeblock
 | identifier
 | macro
 | text
 | number
 | bool
 | column
 | colList
 | numberList
 | boolList
 | stringList
 | numberRanges
 | properties
 | byteSizeValue
 | timeDurationValue
 ;

ifStatement
 : 'if' expression block
   ( 'else' 'if' expression block )*
   ( 'else' block )?
 ;

block
 : OBrace statements CBrace
 ;

expression
 : OParen ( ~OParen | expression )* CParen
 ;

forStatement
 : 'for' OParen Identifier Assign expression SColon expression SColon expression CParen block
 ;

macro
 : Dollar OBrace (~OBrace | macro | Macro)*? CBrace
 ;

pragma
 : '#pragma' (pragmaLoadDirective | pragmaVersion)
 ;

pragmaLoadDirective
 : 'load-directives' identifierList
 ;

pragmaVersion
 : 'version' Number
 ;

codeblock
 : 'exp' Colon condition
 ;

condition
 : OBrace (~CBrace | condition)* CBrace
 ;

properties
 : 'prop' Colon OBrace property ( Comma property )* CBrace
 ;

property
 : Identifier Assign value
 ;

numberRanges
 : numberRange ( Comma numberRange )*
 ;

numberRange
 : Number Colon Number Assign value
 ;

value
 : text
 | number
 | column
 | bool
 ;

identifier
 : Identifier
 ;

ecommand
 : External Identifier
 ;

config
 : Identifier
 ;

column
 : Column
 ;

text
 : String
 ;

number
 : Number
 ;

bool
 : Bool
 ;

command
 : Identifier
 ;

colList
 : Column ( Comma Column )*
 ;

numberList
 : Number ( Comma Number )*
 ;

boolList
 : Bool ( Comma Bool )*
 ;

stringList
 : String ( Comma String )*
 ;

identifierList
 : Identifier ( Comma Identifier )*
 ;

byteSizeValue
 : Number ( BYTE_UNIT_SI | BYTE_UNIT_IEC )
 ;

timeDurationValue
 : Number TIME_UNIT
 ;

OBrace   : '{';
CBrace   : '}';
SColon   : ';';
Or       : '||';
And      : '&&';
Equals   : '==';
NEquals  : '!=';
GTEquals : '>=';
LTEquals : '<=';
Match    : '=~';
NotMatch : '!~';
QuestionColon : '?:';
StartsWith : '=^';
NotStartsWith : '!^';
EndsWith : '=$';
NotEndsWith : '!$';
PlusEqual : '+=';
SubEqual : '-=';
MulEqual : '*=';
DivEqual : '/=';
PerEqual : '%=';
AndEqual : '&=';
OrEqual  : '|=';
XOREqual : '^=';
Pow      : '^';
External : '!';
GT       : '>';
LT       : '<';
Add      : '+';
Subtract : '-';
Multiply : '*';
Divide   : '/';
Modulus  : '%';
OBracket : '[';
CBracket : ']';
OParen   : '(';
CParen   : ')';
Assign   : '=';
Comma    : ',';
QMark    : '?';
Colon    : ':';
Dot      : '.';
At       : '@';
Pipe     : '|';
BackSlash: '\\';
Dollar   : '$';
Tilde    : '~';

Bool
 : 'true'
 | 'false'
 ;

Number
 : Int ( '.' Digit* )?
 ;

BYTE_UNIT_SI  : [kKmMgGtTpP]? 'b';
BYTE_UNIT_IEC : [kKmMgGtTpP] [iI] 'B';

TIME_UNIT
 : [nN] [sS]
 | [uU] [sS]
 | [mM] [sS]
 | [sS]
 | [mM]
 | [hH]
 | [dD]
 ;

Identifier
 : [a-zA-Z_] [a-zA-Z_0-9\-]*
 ;

Macro
 : [a-zA-Z_] [a-zA-Z_0-9]*
 ;

Column
 : ':' [a-zA-Z_] [a-zA-Z_0-9\-:]*
 ;

String
 : '\'' ( EscapeSequence | ~[\\'] )* '\''
 | '"'  ( EscapeSequence | ~[\\"] )* '"'
 ;

Comment
 : ( '//' ~[\r\n]*
   | '/*' .*? '*/'
   | '--' ~[\r\n]*
   ) -> skip
 ;

Space
 : [ \t\r\n\u000C]+ -> skip
 ;

fragment EscapeSequence
 : '\\' ( [btnfr"'\\] | UnicodeEscape | OctalEscape )
 ;

fragment OctalEscape
 : '\\' ('0'..'3') ('0'..'7') ('0'..'7')
 | '\\' ('0'..'7') ('0'..'7')
 | '\\' ('0'..'7')
 ;

fragment UnicodeEscape
 : '\\' 'u' HexDigit HexDigit HexDigit HexDigit
 ;

fragment HexDigit
 : [0-9a-fA-F]
 ;

fragment Int
 : '-'? ( '0' | [1-9] Digit* ) [L]?
 ;

fragment Digit
 : [0-9]
 ;
