[https://andreavitaletti.github.io/](https://andreavitaletti.github.io/)

# Standard flow

* mkdocs serve
* mkdocs build

# To delpoy on github pages

https://www.mkdocs.org/user-guide/deploying-your-docs/

Assuming in the local folder you have the following organization 

```
~/github/mkdocs/andreavitaletti.github.io/
    mkdocs.yml
    docs/
    
~/github/andreavitaletti.github.io/
```
```
cd ~/github/andreavitaletti.github.io/
```
```
mkdocs gh-deploy --config-file ../mkdocs/andreavitaletti.github.io/mkdocs.yml --remote-branch master
```
