all: compile node

compile: 
	coffee --output build/ --compile --bare source/

node:
	node build/server.js
