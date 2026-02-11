[https://andreavitaletti.github.io/](https://andreavitaletti.github.io/)

# [mkdocs](https://www.mkdocs.org/)

# Structure of the directory github

It contains two folders
* mkdocs
* sites
# mkdocs folder

* mkdir mkdocs/new_project
* venv mkdocs
* edit mkdocs.yml
* mkdocs serve
* mkdosc build
# Put sites under git

* mkdir sites/new_project
* cd sites/new_project
* git init
* git remote add origin git@github.com:andreavitaletti/new_project.git

# Standard flow
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
```
(cd ../mkdocs/IoT_short_course/ && mkdocs serve --livereload)
```

# Material for mkdocs

https://squidfunk.github.io/mkdocs-material/

# Slides

The folder Marpit contains a template for markdown slides in [Marpit](https://marpit.marp.app/)

---


