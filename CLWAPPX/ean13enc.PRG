para src
LeftHand_A = "0123456789"
LeftHand_B = "@ABCDEFGHI"
RightHand = "PQRSTUVWXY"
FirstFlag = '!""#$%&()*'
SecondFlag = '"abcdefghi'
Check = "pqrstuvwxy"
strRet = ""
strRet = SUBS(FirstFlag, VAL(SUBS(src,1,1))+1,1)
strRet = strRet + SUBS(SecondFlag, VAL(SUBS(src,2,1))+1,1)
strRet = strRet + SUBS(LeftHand_B, VAL(SUBS(src,3,1))+1,1)
strRet = strRet + SUBS(LeftHand_A, VAL(SUBS(src,4,1))+1,1)
strRet = strRet + SUBS(LeftHand_B, VAL(SUBS(src,5,1))+1,1)
strRet = strRet + SUBS(LeftHand_B, VAL(SUBS(src,6,1))+1,1)
strRet = strRet + SUBS(LeftHand_A, VAL(SUBS(src,7,1))+1,1)
strRet = strRet + chr(124)
for i = 8 to 12
strRet = strRet + SUBS(RightHand, VAL(SUBS(src,i,1))+1,1)
endfor
strRet = strRet + SUBS(Check, VAL(SUBS(src,13,1))+1,1)
RETURN strRet