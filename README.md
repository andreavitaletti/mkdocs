[https://andreavitaletti.github.io/](https://andreavitaletti.github.io/)

# Standard flow

* mkdocs serve
* mkdocs build

# To delpoy on github pages

Assuming in the local folder you have the following organization 

mkdocs/andreavitaletti.github.io/
    mkdocs.yml
    docs/
    
andreavitaletti.github.io/

cd andreavitaletti.github.io/

mkdocs gh-deploy --config-file ../mkdocs/andreavitaletti.github.io/mkdocs.yml --remote-branch master

