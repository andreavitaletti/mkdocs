[https://andreavitaletti.github.io/](https://andreavitaletti.github.io/)

# Structure of the directory github

It contains two folders
* [mkdocs](https://www.mkdocs.org/)
* sites

# Put sites under git

git init
git remote add origin <remote repository URL>

# Standard flow

Enter the directory you want to work with (e.g. IoT_short_course)

* mkdocs serve
* mkdocs build

# [To delpoy on github pages](https://www.mkdocs.org/user-guide/deploying-your-docs/)

Assuming in the local folder you have the following organization 

```
~/github/mkdocs/<mkdocs_folder>/
    mkdocs.yml
    docs/
```
```
cd ~/github/sites/<mkdocs_folder>/
```
```
mkdocs gh-deploy --config-file ../../mkdocs/<mkdocs_folder>/mkdocs.yml --remote-branch master
```

# Material for mkdocs

https://squidfunk.github.io/mkdocs-material/

# Slides

The folder Marpit contains a template for markdown slides in [Marpit](https://marpit.marp.app/)
