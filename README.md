Define a pure function and use it as a console command, possibly performing IO actions on its results.

This library attemts to provide a quickest way to introduce new command to your console world.

Developed for personal use, hopefully useful to outside world.

Example, file add.hs : 

#!/usr/local/bin/runghc 

import Liftconsole

main = (+) @@ "Sum two arguments" // print     --  <--- our IO action on the result of (+) function.
        ^ our pure function  ^
                             ^ description for  --help command

Console:
[Liftconsole l devic 10039]$ add.hs 5 6
11
[Liftconsole l devic 10042]$ add.hs
Not enough arguments, need two arguments.
Sum two arguments
[Liftconsole l devic 10047]$ add.hs --help
Not enough arguments, need two arguments.
Sum two arguments
