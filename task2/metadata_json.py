import urllib.request
import sys
import re

orig_url = "http://169.254.169.254/latest/meta-data/"


def getContents(appended_url):
        contents = "empty"
        list_from_url = ""
        print("url to try is " + appended_url)
        try:
        	contents = urllib.request.urlopen(appended_url.strip()).read()
        	list_from_url = contents.decode('utf-8').split('\n')
        	print(list_from_url)
        except:
        	print("An exception occurred")
        	print(contents)
        return list_from_url

def getJsonMetaData(url):
        list_from_url = ""	
        if url is not "":
                list_from_url= getContents(url)
                if list_from_url is not None and list_from_url is not "":
                        for item in list_from_url:
                                getJsonMetaData(url + "/" + item)
                else:
                        print("returned 404 error")
                        return 0
        else:
                print("else block")

def startLoop():
	counter=0
	getlistItems = getContents(orig_url)
	svc_list = ['ami-id','services']
	print("starting the loop")
	for item in getlistItems:
		counter += 1
		print(counter)
		if counter < 10:
			getJsonMetaData(orig_url + "/" + item)
        	
startLoop()
#if len(sys.argv) > 1:
 #       getJsonMetaData(sys.argv[1])
#else:
#        getJsonMetaData("")

