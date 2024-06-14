# script

## -- The `dcd` toolkit
This is a ***set* of scripts**, predominately written in `bash` and `python3`, aimed to
fill in some of the gaps in the standard suite of manangement and everyday utilities included
by Apple in macOS.  While it could be adapted for some use on other POSIX systems, that is not
the current scope.

## -- Installation
To install, simply place the parent directory (`script`) in `/Users/Shared`; then:
```commandline
(t="$(realpath .)"; v='/Users/Shared'; cp -r "$t" $v; cd "$v/script" && sudo bash install.sh)
```

<i><u><b>Note</i></u>:</b>&nbsp; Only files located in <b>`./script/`</b> marked 
`u+x` are **_symlinked_** into the installation's (usually `/opt/script`) `./bin/`, and runnable by `dcd`.