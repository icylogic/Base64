urlsafe_b64encode(string)
{
    Return b64encode(string, "-_")
}

urlsafe_b64decode(code)
{
    Return b64decode(code, "-_")
}

b64encode(string, altChar:="+/")
{
    StringLeft, altChar, altChar, 2
    Return Base64Encode(string, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" . altChar)
}

b64decode(code, altChar:="+/")
{
    StringLeft, altChar, altChar, 2
    Return Base64Decode(code, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" . altChar)
}

Base64Encode(string, key:="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"){
    StringCaseSense On
    Loop, Parse, string
    {
        index := Mod(A_Index, 3)
        if (index = 1)
        {
            base64Index := ((Asc(A_LoopField) >> 2) & 0x3F)
            lastBin := (Asc(A_LoopField) & 0x03 ) << 4
        }
        else if (index = 2) 
        {
            base64Index := lastBin | ((Asc(A_LoopField) >> 4) & 0x0F)
            lastBin := (Asc(A_LoopField) & 0x0F) << 2       
        }
        else
        {
            base64Index := lastBin | ((Asc(A_LoopField) >> 6) & 0x03)
            StringMid, base64Char, key, base64Index + 1, 1
            code := code base64Char

            base64Index := (Asc(A_LoopField)) & 0x3F
        }
        StringMid, base64Char, key, base64Index + 1, 1
        code := code base64Char
    }
    if (index = 1)
    {
        StringMid, base64Char, key, lastBin + 1, 1
        return code base64Char "=="
    }
    else if (index = 2)
    {
        StringMid, base64Char, key, lastBin + 1, 1
        return code base64Char "="
    }
    else
    {
        return code "=="
    }
}

Base64Decode(code, key:="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"){
    StringReplace code, code, =,,All
    StringReplace, code, code, `r,,All
    StringReplace, code, code, `n,,All
    StringCaseSense On
    Loop, Parse, code
    {
        StringGetPos, currentBin, key, %A_LoopField%
        index := Mod(A_Index, 4)
        if (index = 1)
        {
            lastBin := currentBin << 2
        }
        else if (index = 2)
        {
            string := string Chr(lastBin | (currentBin >> 4))
            lastBin := (currentBin & 0x0F) << 4
        }
        else if (index = 3) 
        {
            string := string Chr(lastBin | (currentBin >> 2))
            lastBin := (currentBin & 0x03) << 6
        }
        else
        {
            string := string Chr(lastBin | currentBin)
        }
    }
    Return string
}