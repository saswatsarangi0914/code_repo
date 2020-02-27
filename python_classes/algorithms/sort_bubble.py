def bubble_sort(lst):
    swap_occured = True
    while swap_occured:
        swap_occured = False
        for i in range(len(lst)-1):
            if lst[i] > lst[i+1]:
                temp = lst[i]
                lst[i]= lst[i+1]
                lst[i+1] = temp
                swap_occured = True

sample_lst = [10,4,6,45,3,2,88]
bubble_sort(sample_lst)
print(sample_lst)


