def insertion_sort(lst):
    for index in range(1,len(lst)):
        currentValue = lst[index]
        position = index

        while position>0 and lst[position-1] > currentValue:
            lst[position] =  lst[position-1]
            position = position -1
        lst[position] = currentValue
    return lst
sample_lst = [10,4,6,45,3,2,88]
print(insertion_sort(sample_lst))    




