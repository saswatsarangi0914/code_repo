def nestedDictonary(data,key):
	if len(key) > 1:
		try:
			return nestedDictonary(data.get(key[0]),key[1:])
		except AttributeError:
			return None
	if len(key) == 1:
		try:
			return data.get(key[0])
		except AttributeError:
			return None
def main():
	data = {"a":{"b":{"c":"d"}}}
	key = "a/b/c"
	keyAsList = key.split("/")
	print(nestedDictonary(data,keyAsList))

if __name__ == '__main__':
    main()

