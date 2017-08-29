# source:
	# https://www.r-bloggers.com/seasonal-trend-decomposition-in-r/

# dataset: monthly tempetures at Nottingham, 1920 - 1939
nottem
str(nottem)

# stl() requires the s.window argument 
nottem.stl = stl(nottem, s.window = "periodic")
plot(nottem.stl)