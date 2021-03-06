#INCLUDE vfp2c.h

&& initialize the library
SET LIBRARY TO vfp2c32.fll ADDITIVE
INITVFP2C32(VFP2C_INIT_MARSHAL)

&& this prg contains the array classes
SET PROCEDURE TO vfp2carray.prg ADDITIVE

&& examples for marshaling arrays

&& create sample data for examples
LOCAL laArray[20]
FOR xj = 1 TO ALEN(laArray)
	laArray[xj] = 1000 * xj
ENDFOR

CREATE CURSOR testCursor(intField I, charField C(50))
FOR xj = 1 TO 20
	INSERT INTO testCursor VALUES (xj,'Hello C ' + ALLTRIM(STR(xj)))
ENDFOR

&& create the C style array class of the correct type
LOCAL loCArray
loCArray = CREATEOBJECT('CIntArray')
&& loCArray = CREATEOBJECT('CShortArray') && short - 16 bit signed integer (WORD)
&& loCArray = CREATEOBJECT('CUShortArray') && unsigned short - 16 bit unsigned integer
&& loCArray = CREATEOBJECT('CUIntArray') && unsigned int - 32 bit unsigned integer
&& loCArray = CREATEOBJECT('CFloatArray') && float - 32bit floating point
&& loCArray = CREATEOBJECT('CDoubleArray') && double - 64bit floating point

&& marshal the FoxPro style array ( !!! pass array by reference !!!)
loCArray.MarshalArray(@laArray)

&& or marshal a field of a cursor ( !!! pass cursor.fieldname as a string !!!)
loCArray.MarshalCursor('testcursor.intField')

&& pass the C style array to some C function 
&& the Address property holds the pointer (memory address) of the C style array
&& someFunc(loCArray.Address)

&& if the array was altered by the function, unmarshal it back 
&& loCArray.UnMarshalArray(@laArray)

&& character arrays
&& C - char[X][X] laArray;
loCArray = CREATEOBJECT('CCharArray')
loCArray.MarshalCursor('testcursor.charfield',50) 
loCArray.MarshalCursor('testcursor.charfield',30) && automatic truncation of field !!

&& C - char* laArray[X];
&& array of pointers to C strings
loCArray = CREATEOBJECT('CStringArray')
loCArray.MarshalCursor('testcursor.charfield')


&& manual construction of C style array - !! rather slow - if the C style array is bigger than a few elements 
&& its faster to create a FoxPro array/cursor and then marshal it with MarshalArray/MarshalCursor

loCArray = CREATEOBJECT('CStringArray')
loCArray.Dimension(10)
FOR xj = 1 TO loCArray.Elements
	loCArray.Element(xj) = 'Hello C ' + ALLTRIM(STR(xj))
ENDFOR

FOR xj = 1 TO loCArray.Elements
	? loCArray.Element(xj)
ENDFOR

loCArray = null
