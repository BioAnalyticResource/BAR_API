
This is Hex's default cache directory. During a docking calculation, Hex 
will write translation matrix files into this directory for future re-use 
(and faster docking!). Depending on the type of calculations you perform, 
Hex could write up to 200MB of data into this directory. If you want to put 
the cache files in a different place (e.g. in a directory/folder on a 
different disc), then you should create a new empty directory and define 
an environment variable called HEX_CACHE which "points to" the new location. 
For example, if you installed Hex under the directory "/somewhere" (and so 
have HEX_ROOT=/somewhere/hex), then the default behaviour is as if you had 
also defined HEX_CACHE=/somewhere/hex/cache. For further details, please 
see the User Manual.
