# bash-setup-util

bash setup support files and util scripts to be loaded in bashrc or profile

## load bash_support/\* in .bashrc like below

```Bash
for f in $WHERE_EVER/THIS_REPO/bash_support/{*,.*}
do
  if [ -f $f ]
  then
    source $f
  fi
done
```
