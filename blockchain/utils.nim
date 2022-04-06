proc `*`*(str: string, num: int) : string =
    var newString = str
    for _ in 1..num:
        newString = str & str

    return newString