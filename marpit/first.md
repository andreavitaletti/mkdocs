---
marp: true
theme: default
paginate: true
---

<style>
/* https://github.com/marp-team/marpit/issues/137 */

section.split {
    overflow: visible;
    display: grid;
    /*
    grid-template-columns: 500px 500px;
    */
    grid-template-columns: 50% 50%;
    grid-template-rows: 100px auto;
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
    /* font-size: 50px;*/
}
section.split .ldiv { grid-area: leftpanel; }
section.split .rdiv { grid-area: rightpanel; }

</style>


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

