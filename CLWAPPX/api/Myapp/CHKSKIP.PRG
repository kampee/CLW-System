*******************************************************************
* Function Check Skip Menu Item 
*******************************************************************
Function chkskip
Para cFormname
with _Screen.formset
    nScreen= .Formcount
    for i = 1 to nScreen
        if upper(allt(.Forms(i).Name)) = upper(allt(cFormname))
            return .T.
        endif
    endfor
endwith
return .F.

