def largestIncreasingSubstr(s):
    #for i in xrange(0,len(s)):
    incList = []
    for k in xrange(0, len(s)):
        subst = s[k]
        i = k+1
        while (i < len(s)):
            if (s[i] > s[i-1]):
                subst = subst + s[i]
            else:
                break
            i = i+1
        incList.append(subst)
    return incList

def findLargest(s):
    theList = largestIncreasingSubstr(s)
    larg = ""
    for stri in theList:
        if (len(stri) > len(larg)):
            larg = stri
    return larg

def findLargestThan(s, K):
    theList = largestIncreasingSubstr(s)
    finalList = []
    for stri in theList:
        if (len(stri) > K):
            finalList.append(stri)
    return finalList
