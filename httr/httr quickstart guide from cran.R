
# library("httr")

# https://cran.r-project.org/web/packages/httr/vignettes/quickstart.html

# there are two important parts to http
	# request - where you request the data sent to the server
	# response - the data sent back from the server

library("httr")


# make the request , then call the GET function with the url as a string:
	# this will print the response
		# gives the actual url used (after any redirects)
		# http status
		# the size
		# if it's a text file
		# the first few lines of the response

r <- GET("http://httpbin.org/get")
r

# you can put the important parts of the response with various helper methods
	# or dig directly into the object

status_code(r)

headers(r)

str(content(r))

# other functions
	# in addition to GET() you can use the functions 
		# HEAD()
		# PATCH()
		# PUT()
		# DELETE()
		# GET()
		# POST()
		# PATCH()
		# DELETE()

# the status code:
	# a three digit number that summarises whether or not the request was succesful (as defined by the server you are talking to)
	# you can access the status code along with a descriptive message using http_status()
		# a successful request always returns a status of 200
		# common errors are: 
			# 404 (file not found)
			# 403 (permission denied)
			# if you're talking to web APIs you might also see 500 ( a generic failure code)

http_status(r)

# you can automatically throw a warning or raise an error if a request did not succeed
	# these are recommended if your using library(httr) inside a function
	# this will make sure you find out about the error as soon as possible

warn_for_status(r)
stop_for_status(r)

# the body
	# there are thre ways to access the body
		# all using the content() function

# access the body as a charecter vector
content(r, "text")

# httr will automatically decode content from the server using the encoding supplied in the content-type HTTP header
	# but you can't always trust what the server tells you
	# you can override encoding if needed with:

content(r, "text", encoding = "ISO-8859-1")

# if you're having problems figuring out wha tthe correct encoding should be, try

stringi::stri_enc_detect(content(r, "raw"))

# for non-text requests, you can access the body of the request as a raw vector
	# this is exactly the sequence of bytes that the web server sent
		# this is the highest fidelity way of saving fiels to a disk

content(r, "raw")

bing <- content(r, "raw")
writeBin(bin, "myfile.txt")

