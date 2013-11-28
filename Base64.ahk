StringCaseSense On
Chars = ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/   

Base64Encode(string) {
   Loop Parse, string
   {
      m := Mod(A_Index,3)
      IfEqual      m,1, SetEnv buffer, % Asc(A_LoopField) << 16
      Else IfEqual m,2, EnvAdd buffer, % Asc(A_LoopField) << 8
      Else {
         buffer += Asc(A_LoopField)
         out := out Code(buffer>>18) Code(buffer>>12) Code(buffer>>6) Code(buffer)
      }
      If Mod(A_Index, 81) = 0 
        out := out chr(13) chr(10)
   }
   IfEqual m,0, Return out
   IfEqual m,1, Return out Code(buffer>>18) Code(buffer>>12) "~~" 
   Return out Code(buffer>>18) Code(buffer>>12) Code(buffer>>6) "~"
}

Base64Decode(code) {
   StringReplace code, code, ~,,All
   StringReplace, code, code, `r,,All
   StringReplace, code, code, `n,,All
   Loop Parse, code
   {
      m := A_Index & 3 ; mod 4
      IfEqual m,0, {
         buffer += DeCode(A_LoopField)
         out := out Chr(buffer>>16) Chr(255 & buffer>>8) Chr(255 & buffer)
      }
      Else IfEqual m,1, SetEnv buffer, % DeCode(A_LoopField) << 18
      Else buffer += DeCode(A_LoopField) << 24-6*m
   }
   IfEqual m,0, Return out
   IfEqual m,2, Return out Chr(buffer>>16)
   Return out Chr(buffer>>16) Chr(255 & buffer>>8)
}

Code(i) {
   Global Chars
   StringMid i, Chars, (i&63)+1, 1
   Return i
}

DeCode(c) {
   Global Chars
   Return InStr(Chars,c,1) - 1
}