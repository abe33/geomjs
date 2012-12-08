## GeomJS

[![Build Status](https://travis-ci.org/abe33/geomjs.png)](https://travis-ci.org/abe33/geomjs)

[Try It](http://abe33.github.com/geomjs/demos/demo.html)

**GeomJS** is a small utility that provides many geometric primitives such
`Triangle`, `Circle` or `Rectangle`; and more complex geometries
such `Polygon`, `Diamond` or bezier splines.

**GeomJS** can be used both on NodeJS and in the browser.

The library is articulated around several interfaces that all geometries
implements, with an exception for the `Surface` interface that can't possibly
be implemented by splines.
Below the list of the interfaces and their roles:

 * `Geometry`: All geometries provides methods to retrieve an array of points
   corresponding to their display shape, retrieve their bounds and draw the
   geometry on a canvas.
 * `Path`: All geometries have an outline, and this outline can be used as
   a path, providing both points and orientation on the path at a given
   position.
 * `Surface`: All geometries, except splines and spiral, provides method
   to retrieve the surface acreage or to retrieve a random point in the
   surface.
 * `Triangulable`: All surface geometries can return an array containing
   the triangulated version of the geometry.
 * `Intersections`: All geometries can intersect with each other.
 * `Sourcable`: All geometries can return the source code of their current
   state.
 * `Cloneable`: All geometries can return a copy of themselves.
 * `Equatable`: All geometries provides a `equals` method to compare
   instances of the same class.

### Getting Started

#### NodeJS

Install through npm:

    npm install geomjs

Then require it as follow:

    geomjs = require 'geomjs'

    rect = new geomjs.Rectangle 0, 0, 100, 50

#### Browser

Download MixinsJS, ChanceJS and GeomJS packaged version:

**MixinsJS**:
 * [uncompressed](https://raw.github.com/abe33/mixinsjs/master/packages/mixinsjs.js)
 * [compressed](https://raw.github.com/abe33/mixinsjs/master/packages/mixinsjs.min.js)

**ChanceJS**:
 * [uncompressed](https://raw.github.com/abe33/chancejs/master/packages/chancejs.js)
 * [compressed](https://raw.github.com/abe33/chancejs/master/packages/chancejs.min.js)

**GeomJS**:
 * [uncompressed](https://raw.github.com/abe33/geomjs/master/packages/geomjs.js)
 * [compressed](https://raw.github.com/abe33/geomjs/master/packages/geomjs.min.js)

Adds it in your html page:

    <script src='./mixinsjs.min.js'></script>
    <script src='./chancejs.min.js'></script>
    <script src='./geomjs.min.js'></script>

Then use it as follow:

    rect = new geomjs.Rectangle 0, 0, 100, 50
