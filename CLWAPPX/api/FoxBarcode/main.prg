*--------------------------------------------------------------------------------------
* MAIN.PRG
*--------------------------------------------------------------------------------------
* Version: 0.12 Beta
* Date   : 2010-11-29
* Author : VFPEncoding
* Email  : vfpencoding@gmail.com
*
* Note   : VFPEncoding are 
*          Guillermo Carrero (Barcelona, Spain) and 
*          Luis Maria Guayan (Tucuman, Argentina)
*--------------------------------------------------------------------------------------
LOCAL lcPath

lcPath = ADDBS(JUSTPATH(SYS(16,1)))

SET DEFAULT TO (lcPath)
SET PROCEDURE TO Source\FoxBarcode, Source\gpimage2 ADDITIVE
*-- SET HELP TO Docs\FoxBarcode.chm

DO FORM ("Forms\FoxBarcode")
READ EVENTS

CLEAR RESOURCES

*--------------------------------------------------------------------------------------

