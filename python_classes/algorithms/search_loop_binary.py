def binarySearch(searchLst,value):
    searchLst.sort()
    min = 0
    max = len(searchLst) - 1

    while min < max:
        currentMiddle = (min + max) // 2
        if searchLst[currentMiddle] == value:
            return True

        elif value < searchLst[currentMiddle]:
            max = currentMiddle - 1

        elif value > searchLst[currentMiddle]:
            min = currentMiddle + 1

    return False


listT = [1,5,2,4,7,3]
print(binarySearch(listT,10))