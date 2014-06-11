kdbWorkshop
===========
http://code.kx.com/workshop/

prepend \t to the command then u will get the millsec taken for the command
saving table
1) into a flat file (slow to read as everything in one file)
2) splaying into muliple files 
	`:tmp/ws/ set .Q.en[
3) partition the data by time and then splay by column

splay and partition could be faster depending if you wanna look at specific time or specific column, etc

in where clause, use , instead of and to have multiple clauses
 - and will look thru everything
 - , will look clause by clause and the data needed
	- so, u'd like to use the clause that matches your db struct, say date first for partition table
