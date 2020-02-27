def fibonacci(num):
    if num==1 or num==2:
        return 1
    else:
        return fibonacci(num-1) + fibonacci(num-2)    

print("fibonacci of 10 is",fibonacci(10))