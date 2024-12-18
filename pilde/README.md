# pilde



## Per vedere il blog in modo grazioso 

[https://docsify-this.net/?basePath=https://raw.githubusercontent.com/andreavitaletti/pilde/main/docs&homepage=index.md&sidebar=true#/](https://docsify-this.net/?basePath=https://raw.githubusercontent.com/andreavitaletti/pilde/main/docs&homepage=index.md&sidebar=true#/)

## Per stampare su due colonne  

The content of the head.yaml file 
```
--- 
 classoption:
 - twocolumn 
 author: Andrea Vitaletti 
---
```

```
pandoc --resource-path="docs" ./docs/blog_2006.md head.yaml -s -o ./pdf/blog_2006.pdf
```