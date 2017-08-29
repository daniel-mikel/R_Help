# Run R from Sublime

# Open the Sublime console (not R console) 
	# "ctrl + ~"

###########################
# Starting a New R Script #
###########################

# if this is your first time running sublime from R
	# you'll need to first install the packages in the next section
	# then come back here

# when you open a new script you'll need to set the the following packages:
	# Set Syntax: R
	# REPL: R

# Open Sencond Window for R Console 

# open second window:
	# press "alt + shift + 2" or "alt + shift + 8"
		# gives you 2 windows split either vertically or horizontally
# close second window:
	# press "ctrl + shift + 1"

#######################
# Set Up R in Sublime #
#######################

# note that you'll need to install the Package Control Manager
	# https://packagecontrol.io/installation

# based on tutorial from
	#http://www.kevjohnson.org/using-r-in-sublime-text-3/

# to open the R console:
	# Ctrl + Shift + P
	# then type REPL R
	# have two windows (one for console)
		# Alt + Shift + 2
		# now you can have your R concole on the right, and the editor on your left
		# you can even seperate them and have them on different monitors


# suggested packages:
		# from https://www.r-bloggers.com/sublime-text-3-an-alternative-to-rstudio/
		# install packages with Ctrl + Shift + P then "Install Package"
		# View packages Ctrl + Shift + P "Package Control: Check Package"
	# SublimeREPL
	# R-Box
	# SendCode (SendText available, SendCode was SendTextPlus)
	# R-Snippets
# suggested preferences
	# R-Snippets
	# R Extended
	# SendCode: Choose Program
		# then select R (for me REPL R)
	# REPL:R
		# may be required for each new script opened

# i had trouble with one of the dependencies "tmux", I forgot which package it was
	# problem in Ubuntu 16.04 LTS and 17.04
		# this is usally why my R code won't send to REPL
	# found solution here:
		# https://github.com/nZEDb/nZEDb/issues/2182


###############
# Preferences #
###############

# allow word wrapping on your documents
	# http://justinseeley.com/tutorials/quick-tip-enable-sublime-text-word-wrap

# parenthesis highlighting
	# BracketHighlighter