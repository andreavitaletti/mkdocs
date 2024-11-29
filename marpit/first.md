---
marp: true
theme: beam
paginate: true
header: '[Get in touch](#contacts)'
footer: 'Footer content'
---

<style>

/* 2 side-by-side blocks */

/* https://github.com/marp-team/marpit/issues/137 */

section.split {
    overflow: visible;
    display: grid;
    /*
    grid-template-columns: 500px 500px;
    */
    grid-template-columns: 50% 50%;
    grid-template-rows: auto auto;
    grid-template-areas: 
        "slideheading slideheading"
        "leftpanel rightpanel";
}
/* debug */
section.split h1, 
section.split .ldiv, 
section.split .rdiv,
section.split h1 {
    grid-area: slideheading;
}
section.split .ldiv { grid-area: leftpanel; }
section.split .rdiv { grid-area: rightpanel; }

/* Subtitle in Title only */

section.title h2 {
  text-align: center;
}

/* Fonts */

@import 'https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css';

/* Colors */
/*
 :root {
    --main: #bbb;
    --secondary: #333;
  }

 header{
    color: #123
 }
 footer{
    color: #123
 }
*/
</style>

<!-- _class: title -->

# Titolo

## Andrea Vitaletti

---

# Slide 1

foobar

![bg](https://fakeimg.pl/800x600/0288d1/fff/?text=A)
![bg](https://fakeimg.pl/800x600/02669d/fff/?text=B)
![bg](https://fakeimg.pl/800x600/67b8e3/fff/?text=C)

<!-- HTML comment recognizes as a presenter note per pages. -->
<!-- You may place multiple comments in a single page. -->

---

# A split slide
<!-- _class: split -->

<div class=ldiv>

## Title for the left panel
- listed item
- listed item
- listed item
</div>
<div class=rdiv>

## Title for the right panel
- listed item
- listed item
- listed item
</div>

---

# A split slide

<!-- _class: split -->

<div class=ldiv>


[![left](https://img.youtube.com/vi/JtxkxqS6JOc/0.jpg)](https://www.youtube.com/watch?v=JtxkxqS6JOc)
</div>

<div class=rdiv>

## Title for the right panel
- listed item
- listed item
- listed item
</div>

---

# Video

Non si vede su Vscode, ma è ok quando si esporta.

<iframe width="560" height="315" src="https://www.youtube.com/embed/JtxkxqS6JOc?si=0jyMLbfZPcN5JL6I" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

---

<!-- Scoped style -->
<style scoped>
h1 {
  color: red;
}
</style>


# Bullet list

- One
- Two
- Three

---

# Fragmented list

* One
* Two
* Three

---

# Video 

[![width:200px](https://img.youtube.com/vi/JtxkxqS6JOc/0.jpg)](https://www.youtube.com/watch?v=JtxkxqS6JOc)

---

<!-- _backgroundColor: aqua -->


# Slide 233

foobar

![](assets/images/2024-11-28-12-54-34.png)

---

# Slide 3

![bg vertical](https://fakeimg.pl/800x600/0288d1/fff/?text=A)
![bg](https://fakeimg.pl/800x600/02669d/fff/?text=B)
![bg](https://fakeimg.pl/800x600/67b8e3/fff/?text=C)

--- 

![bg left](https://picsum.photos/720?image=29)

# Split backgrounds

The space of a slide content will shrink to the right side.

---

![bg right](https://picsum.photos/720?image=3)
![bg](https://picsum.photos/720?image=20)
![bg](https://picsum.photos/720?image=20)
![bg](https://picsum.photos/720?image=20)
![bg](https://picsum.photos/720?image=20)

# Split + Multiple BGs

The space of a slide content will shrink to the left side.

---

![bg left:33%](https://picsum.photos/720?image=27)

# Split backgrounds with specified size

---

$\frac{1}{2}$

---

# Contacts

<i class="fa fa-linkedin-square" aria-hidden="true"> &nbsp; [https://www.linkedin.com/in/andreavitaletti/](https://www.linkedin.com/in/andreavitaletti/)</i>


<i class="fa fa-envelope" aria-hidden="true"> &nbsp; [vitaletti@diag.uniroma1.it](vitaletti@diag.uniroma1.it)
</i>

<i class="fa fa-github-square" aria-hidden="true"> &nbsp; [https://github.com/andreavitaletti](https://github.com/andreavitaletti)</i>


--- 

<img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB3aWR0aD0iMjUwbW0iIGhlaWdodD0iNS4zNTQ2bW0iIHZlcnNpb249IjEuMSIgdmlld0JveD0iMCAwIDI1MCA1LjM1NDYiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxnIHRyYW5zZm9ybT0idHJhbnNsYXRlKC0yMC4zNDcgLTkxLjAyOCkiPgo8cmVjdCB4PSIyMC4zNDciIHk9IjkxLjAyOCIgd2lkdGg9IjEyNSIgaGVpZ2h0PSI1LjM1NDYiIGZpbGw9IiMxNDE0MTQiIGZpbGwtcnVsZT0iZXZlbm9kZCIgc3Ryb2tlLXdpZHRoPSIwIi8+CjxwYXRoIGQ9Im0xNDUuMzUgOTMuNzA1di0yLjY3NzNoMTI1djUuMzU0NmgtMTI1eiIgZmlsbD0iIzFmMzhjNSIgc3Ryb2tlLXdpZHRoPSIwIi8+CjwvZz4KPC9zdmc+"/>